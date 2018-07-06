require 'test_helper'

module Workarea
  class Payment
    class FlowCreditCardIntegrationTest < Workarea::TestCase

      include FlowIoVCRConfig

      def test_store_auth
        VCR.use_cassette 'credit_card/flow/store_auth' do
          transaction = tender.build_transaction(action: 'authorize')
          Payment::Authorize::Flow.new(tender, transaction).complete!
          assert(transaction.success?, 'expected transaction to be successful')

          assert(tender.token.present?)
        end
      end

      def test_store_purchase
        VCR.use_cassette 'credit_card/flow/store_purchase' do
          transaction = tender.build_transaction(action: 'purchase')
          Payment::Purchase::Flow.new(tender, transaction).complete!
          assert(transaction.success?)

          assert(tender.token.present?)
        end
      end

      def test_auth_capture
        VCR.use_cassette 'credit_card/flow/auth_capture' do
          transaction = tender.build_transaction(action: 'authorize')
          Payment::Authorize::Flow.new(tender, transaction).complete!
          assert(transaction.success?)
          transaction.save!

          assert(tender.token.present?)

          capture = Payment::Capture.new(payment: payment)
          capture.allocate_amounts!(total: 5.to_m)
          assert(capture.valid?)
          capture.complete!

          capture_transaction = payment.transactions.detect(&:captures)
          assert(capture_transaction.valid?)
        end
      end

      def test_auth_void
        VCR.use_cassette 'credit_card/flow/auth_void' do
          transaction = tender.build_transaction(action: 'authorize')
          operation = Payment::Authorize::Flow.new(tender, transaction)
          operation.complete!
          assert(transaction.success?, 'expected transaction to be successful')
          transaction.save!

          assert(tender.token.present?)

          operation.cancel!
          void = transaction.cancellation

          assert(void.success?)
        end
      end

       def test_auth_capture_refund
        pass && return unless Workarea.config.run_credit_card_refund_tests

        VCR.use_cassette 'credit_card/flow/auth_capture_refund' do
          transaction = tender.build_transaction(action: 'authorize')
          Payment::Authorize::Flow.new(tender, transaction).complete!
          assert(transaction.success?, 'expected transaction to be successful')
          transaction.save!

          assert(tender.token.present?)

          capture = Payment::Capture.new(payment: payment)
          capture.allocate_amounts!(total: 5.to_m)
          assert(capture.valid?)
          capture.complete!

          capture_transaction = payment.transactions.detect(&:captures)
          assert(capture_transaction.valid?)

          refund = Payment::Refund.new(payment: payment)
          refund.allocate_amounts!(total: 5.to_m)

          assert(refund.valid?)
          refund.complete!

          refund_transaction = payment.credit_card.transactions.refunds.first
          assert(refund_transaction.valid?)
        end
      end

      def test_purchase_refund
        pass && return unless Workarea.config.run_credit_card_refund_tests

        VCR.use_cassette 'credit_card/flow/purchase_refund' do
          transaction = tender.build_transaction(action: 'purchase')
          Payment::Purchase::Flow.new(tender, transaction).complete!
          assert(transaction.success?)
          transaction.save!

          assert(tender.token.present?)

          refund = Payment::Refund.new(payment: payment)
          refund.allocate_amounts!(total: 5.to_m)

          assert(refund.valid?)
          refund.complete!

          refund_transaction = payment.credit_card.transactions.refunds.first
          assert(refund_transaction.valid?)
        end
      end

      private

      def gateway
        Workarea::FlowIo.gateway
      end

      def payment
        @payment ||=
          begin
            profile = create_payment_profile
            order = create_order
            create_payment(
              operation_tender_type: 'Flow',
              id: order.id,
              profile_id: profile.id,
              address: {
                first_name: 'Ben',
                last_name: 'Crouse',
                street: '22 s. 3rd st.',
                city: 'Philadelphia',
                region: 'PA',
                postal_code: '19106',
                country: Country['US']
              }
            )
          end
      end

      def tender
        @tender ||=
          begin
            payment.set_address(first_name: 'Ben', last_name: 'Crouse')

            payment.build_credit_card(
              number: 4012888888881881,
              month: 1,
              year: Time.current.year + 1,
              cvv: '999',
              amount: 5.to_m
            )

            payment.credit_card
          end
      end
    end
  end
end

