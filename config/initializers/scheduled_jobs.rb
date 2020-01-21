unless Workarea.config.skip_service_connections
  if Workarea::FlowIo.credentials.key?(:ftp_username) && Workarea::FlowIo.credentials.key?(:ftp_password)
    Sidekiq::Cron::Job.create(
      name: 'Workarea::FlowIo::FetchImport',
      klass: 'Workarea::FlowIo::FetchImport',
      cron: "0 9 * * * #{Time.zone.tzinfo.identifier}"
    )
  end
end
