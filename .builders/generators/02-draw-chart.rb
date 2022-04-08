KManager.action :bootstrap do
  action do
    director = KDirector::Dsls::BasicDsl
      .init(k_builder,
        template_base_folder:       'drawio',
        on_exist:                   :skip,                      # %i[skip write compare]
        on_action:                  :queue                      # %i[queue execute]
      )
      .data(
      )
      .blueprint(
        active: true,
        name: :build_graph,
        description: 'build a graph',
        on_exist: :write) do

        cd(:graph)

        debug
        add('xmen.txt', template_file: 'main.drawio')
        add('xmen.drawio', template_file: 'main.drawio')
        oadd('test.drawio', template_file: 'main.drawio')

      end

    director.play_actions
  end
end

KManager.opts.app_name                    = 'k_manager'
KManager.opts.sleep                       = 2
KManager.opts.reboot_on_kill              = 0
KManager.opts.reboot_sleep                = 4
KManager.opts.exception_style             = :short
KManager.opts.show.time_taken             = true
KManager.opts.show.finished               = true
KManager.opts.show.finished_message       = 'FINISHED :)'
