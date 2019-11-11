module Workarea
  module FlowIo
    # Fetches new import CSVs from the FTP server, ignoring any that
    # have already been processed.
    class FetchImport
      include Sidekiq::Worker

      sidekiq_options lock: :until_executing

      def perform
        username = FlowIo.credentials[:ftp_username]
        password = FlowIo.credentials[:ftp_password]
        path = Pathname.new('flow').join('from-flow', 'export')

        Net::SFTP.start(FlowIo::FTP_HOST, username, password: password) do |sftp|
          sftp.dir.glob(path.to_s, '*.csv') do |entry|
            Import.find_or_create_by!(name: entry.name) do |import|
              sftp.file.open(path.join(entry.name).to_s) do |file|
                tmp = Tempfile.new(entry.name)
                tmp.write(file.gets)
                tmp.close

                import.file = tmp
              end
            end
          end
        end
      end
    end
  end
end
