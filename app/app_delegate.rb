class AppDelegate < PM::Delegate
  status_bar true, animation: :none

  def on_load(app, options)
    return true if RUBYMOTION_ENV == "test"

    load_data
    Event.destroy_all
    Person.destroy_all
    load_seed_data if Event.count == 0
    start_model_observers

    open EventsScreen.new(nav_bar: true)
  end

  ################ Persistence Is Handled in Asynchronous Queue #################
  def observe_change
    @model_change_observer = App.notification_center.observe MotionModelDataDidChangeNotification do |notification|
      queue = Dispatch::Queue.concurrent('com.calicowebdev.whos_here.task')
      queue.async{
        begin
          save_one(notification.object.class)
        rescue MotionModel::PersistFileError => ex
          App.notification_center.post MotionModelPersistFileError, Time.now,
                                            {:status => 'failure', :exception => ex.message}
        end
        file_sizes
      }
    end
  end

  def observe_failure
    @persist_failure = App.notification_center.observe MotionModelPersistFileError do |notification|
      if notification.userInfo[:status] == 'failure'
        App.alert "Unable to update your data on the device.\nError: #{notification.userInfo[:exception]}"
      end
    end
  end

  def start_model_observers
    observe_change
    observe_failure
  end
  #############################################################################

  def file_sizes
   [Event, Person].each do |klass|
      name = klass.to_s.downcase
      names = name.pluralize
      begin
        file = File.join(
            NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true),
            "#{names}.dat"
            )
      rescue MotionModel::Exception => ex
        Debug.info ex.message
      end
    end
  end

  def load_data
    [Event, Person].each do |klass|
      name = klass.to_s.downcase
      names = name.pluralize
      begin
        klass.deserialize_from_file("#{names}.dat")
      rescue MotionModel::PersistFileFailureError => ex
        NSLog "There do not appear to be any #{names} yet.\nMaking a new list."
      end
    end
  end

  def save_one(klass)
    name = klass.to_s.downcase
    names = name.pluralize
    klass.serialize_to_file("#{names}.dat")
  end

  def save_data(*args)
    if args.length == 0
      [Event, Person].each{|klass| save_one klass}
    else
      args.each{|klass| save_one klass}
    end
    file_sizes
  end

  def load_seed_data
    Debug.info "adding people"

    e1 = Event.create(event_name: 'Music Awards',
        event_location: 'Kodak Theater',
        event_date: '3/23/2013',
        contact_email: 'me@me.com',
        contact_phone: '111-222-3333')
    e2 = Event.create(event_name: 'After Party',
        event_location: 'Voodoo Lounge',
        event_date: '3/24/2013',
        contact_email: 'you@me.com',
        contact_phone: '222-333-4444')

"""
Audria Alsobrook
Ferdinand Eberly
Britni Medlin
Rheba Aoki
Evelina Gullickson
Erlinda Penman
Dylan Arrington
Chae Screws
Kimbra Scheele
Leisa Apodaca
Magdalene Theroux
Bernardina Griffieth
Carmelita Didion
Patty Palafox
Gayle Heintzelman
Cherryl Hathorn
Renate Galgano
Evie Culver
Hailey Weigel
Jolie Lefkowitz
Audrea Lamay
Naoma Stours
Detra Bristow
Hulda Poe
Denise Belanger
Brande Abarca
Fredricka Hursey
Maurice Sawtelle
Clair Redwine
Jamison Travers
Serafina Teasley
Jay Armstrong
Yoshiko Arnett
Porfirio Mckellar
Agueda Artis
Lashay Byers
Renato Maliszewski
Cecilia Nye
Teddy Segraves
Gene Caryl
Odilia Dansby
Daniella Lansberry
Jina Deerman
Lyda Ellithorpe
Margrett Natal
Florance Molinar
Elda Rhoades
Pasty Hoggatt
Eric Jelinek
Gregory Spahr
""".split("\n").each do |line|
  next if line.strip.length < 1
  names = line.split(" ")
  p = e1.people.create(first_name: names.first, last_name: names.last, people_attending: Random.rand(10))
end
  end
end
