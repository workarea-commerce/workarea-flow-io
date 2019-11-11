require 'test_helper'

module Workarea
  module FlowIo
    class FetchImportTest < TestCase
      def test_fetch_csv_from_ftp_and_store
        username = 'admin'
        password = 'hunter2'
        fixture = FlowIo::Engine.root.join(
          'test', 'fixtures', 'files', 'example.csv'
        )
        file = mock('Net::SFTP::Operations::File')
        path = Pathname.new('flow').join('from-flow', 'export')
        dir = mock('Net::SFTP::Operations::Dir')
        sftp = mock('Net::SFTP::Session')
        handler = mock('Net::SFTP::Operations::FileHandler')
        entry = mock('Net::SFTP::Operations::Entry')

        entry.expects(:name).at_least_once.returns(fixture.basename.to_s)
        file.expects(:gets).returns(fixture.read)
        dir.expects(:glob).twice.with(path.to_s, '*.csv').yields(entry)
        handler.expects(:open).with(path.join(fixture.basename).to_s).yields(file)
        sftp.expects(:dir).at_least_once.returns(dir)
        sftp.expects(:file).returns(handler)
        FlowIo.expects(:credentials).at_least_once.returns(
          ftp_username: username,
          ftp_password: password
        )
        Net::SFTP.expects(:start).twice.with(
          FlowIo::FTP_HOST,
          username,
          password: password
        ).yields(sftp)

        assert_difference -> { Import.count } do
          FetchImport.new.perform
        end
        assert_equal(fixture.basename.to_s, Import.all.first.name)
        assert_no_difference -> { Import.count } do
          FetchImport.new.perform
        end
      end

      def test_prevent_importing_the_same_csv_twice
        username = 'admin'
        password = 'hunter2'
        fixture = FlowIo::Engine.root.join(
          'test', 'fixtures', 'files', 'example.csv'
        )
        path = Pathname.new('flow').join('from-flow', 'export')
        dir = mock('Net::SFTP::Operations::Dir')
        sftp = mock('Net::SFTP::Session')
        entry = mock('Net::SFTP::Operations::Entry')

        entry.expects(:name).at_least_once.returns(fixture.basename.to_s)
        dir.expects(:glob).with(path.to_s, '*.csv').yields(entry)
        sftp.expects(:dir).at_least_once.returns(dir)
        FlowIo.expects(:credentials).at_least_once.returns(
          ftp_username: username,
          ftp_password: password
        )
        Net::SFTP.expects(:start).with(
          FlowIo::FTP_HOST,
          username,
          password: password
        ).yields(sftp)

        Import.create!(name: fixture.basename, file: fixture.open)
        assert_no_difference -> { Import.count } do
          FetchImport.new.perform
        end
      end
    end
  end
end
