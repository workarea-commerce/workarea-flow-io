module Workarea
  class FlowPriceAdjustmentSet < Array
    attr_reader :experience

    # @param [Workarea::PriceAdjustment] price_adjustments
    # @param (::Io::Flow::V0::Models::ExperienceSummary || ::Io::Flow::V0::Models::ExperienceGeo) experience
    #
    def initialize(price_adjustments, experience)
      super(price_adjustments)
      @experience = experience
    end

    def select(*args)
      self.class.new(super, experience)
    end

    def reject(*args)
      self.class.new(super, experience)
    end

    def adjusting(type)
      select { |a| a.price == type }
    end

    def sum
      super(&:amount).to_m(experience.currency)
    end

    def discounts
      select(&:discount?)
    end

    def +(val)
      self.class.new(to_a + val.to_a, experience)
    end

    def reduce_by_description(type)
      amounts = adjusting(type).reduce({}) do |memo, adjustment|
        memo[adjustment.description] ||= 0.to_m(experience.currency)
        memo[adjustment.description] += adjustment.amount
        memo
      end

      self.class.new(
        amounts.keys.map do |description|
          PriceAdjustment.new(
            description: description,
            amount: amounts[description]
          )
        end,
        experience
      )
    end

    def taxable_share_for(adjustment)
      return 0.to_m(experience.currency) if taxable_total.zero?

      discount_share = adjustment.amount / taxable_total
      discount_amount = discount_total * discount_share
      adjustment.amount - discount_amount
    end

    def grouped_by_parent
      each_with_object({}) do |adjustment, memo|
        memo[adjustment._parent] ||= PriceAdjustmentSet.new
        memo[adjustment._parent] << adjustment
      end
    end

    private

    def taxable_total
      reject { |a| a.discount? || a.data['tax_code'].blank? }.sum(&:amount).to_m(experience.currency)
    end

    def discount_total
      discounts.sum(&:amount).to_m(experience.currency).abs
    end
  end
end
