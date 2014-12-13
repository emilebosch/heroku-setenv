require 'thor'
require 'YAML'
require 'hashdiff'
require 'pp'

module SetEnv
	class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts SetEnv::VERSION
    end

    desc "init", "Sets up your env environment"
    def init
      # Check dependencies
      %w(git heroku gpg tar).each { |k|  die "No #{k} command found, did u install #{k}?" if `which #{k}`.strip.empty? }

      die "An env directory is already present." if Dir.exists? "env"
      
      # Create env directories
      # mkdir "./env/services"
      # heroku_remotes.keys.each { |k|
      #   mkdir "./env/.remotes/#{k}"
      # }

      # Add directories to env file
      out "Adding to .gitignore"
      `echo "\nenv" >> .gitignore`

      for k,v in heroku_remotes
        export k
      end
    end

    desc "config", "Show the current config settings on heroku"
    option :remote
    def config(remote)
      out heroku_command("config", remote)
    end

    # desc "reset [REMOTE]", "Reset an REMOTE to its DEFAULT settings"
    # def reset
    # end

    # desc "set [REMOTE] [SERIVCE] [ENV]", "Set [remote] to [environment] settings"
    # def set
    #   # SETS A SPECIFC REMOTE
    # end

    # desc "add [SERVICE] [KEY=VAL]..", "Add a service "
    # def add(service)
    #   # CREATES A NEW SERVICE FILE
    # end

    desc "apply [remote]", "Applies the locall diff changes to heroku remote"
    def apply(remote)
      diff = get_diff remote   
      pp diff 
    end

    desc "diff", "Diff remote with current .yml"
    def diff(remote)
      diffs   = get_diff remote
      for k in diffs
        out " #{k[0]} #{k[1]}"
        out "\s\sOn Heroku\t\t:#{k[2]}"
        out "\s\sLocal cache \t\t:#{k[3]}"
      end
    end

    desc "plan", "Plan the changes to be done to heroku"
    def plan(remote)
      diffs   = get_diff remote      
      plan    = diffs.group_by {|k|k[0]}
      out "Changes to be done to #{remote} after this run"
      out "--"
      
      plan['-'].each {|key| out "Will unset #{key[1]}=#{key[2]}" } if plan['-']      
      plan['+'].each {|key| out "Will set #{key[1]}=#{key[2]}" } if plan['+']
      plan['~'].each {|key| out "Will change #{key[1]}=#{key[2]} to: #{key[3]}" } if plan['~']
    end

    desc "clobber", "Removes all traces of setenv"
    def clobber
      out "Removing all traces of setenv.."
      f.rm_rf "./env"
      f.rm_f "env.tgz.gpg"
    end

    desc "encrypt", "Encrypt your env variables"
    def encrypt
      die "No ENV directory to encrypt" unless Dir.exists? "env"
      out "Encryping.."
      `tar cvz -f env.tgz ./env && gpg -c env.tgz && rm -rf ./env`
      `rm -rf env.tgz` # always delete the tgz in order to ensure no accidental checkins.
    end

    desc "decrypt", "Decrypt your env variables"
    def decrypt
      out "Decrypting.."
      `gpg env.tgz.gpg && tar -zxvf env.tgz && rm env.tgz`
    end

    desc "export", "Export settings from heroku and save to local file"
    option :remote
    def export(remote)
      config = get_remote_config(remote)
      write_yaml("./env/#{remote}.yml", config)
    end

    private

    def command(cmd)
      env = {'PATH' => ENV['PATH'], 'HOME' => ENV['HOME']}
      rd, wr = IO.pipe
      pid = fork do
        rd.close
        $stdout.reopen(wr)
        exec(env, cmd, :unsetenv_others=>true)         
      end

      wr.close
      Process.waitpid(pid)
      rd.read
    end

    def heroku_command(command, remote)
      app =  heroku_remotes[remote]
      unless app
        out "App not found: '#{remote}'"
        show_apps
        exit 1
      end
      command("heroku #{command} --app #{app}")
    end

    def out(str)
      puts str
    end

    def f
      FileUtils
    end

    def show_apps
      out "Available remotes:"
      heroku_remotes.each { |k,v| out "- '#{k}' mapped to #{v}"}      
    end

    def mkdir(d)
      puts "creating: #{d}"
      f.mkdir_p d      
    end

    def get_remote_config(remote)
      data = heroku_command("config", remote)
      a = data.scan /(.*?)\:\s(.*?)\n/
      envs = {} 
      a.each { |k| envs[k[0].strip] = k[1].strip }
      envs     
    end

    def heroku_remotes
      x =  `git remote -v`
      r = x.scan  /^(.*?)\t.*?heroku\.com\:(.*?)\.git(.*?)\(push\)/
      a = {}
      r.map { |r| a[r[0]] = r[1] }
      a
    end

    def die(str)
      out str
      exit 1
    end
    
    def get_diff(remote)
      live = get_remote_config(remote)
      cached = YAML.load_file "env/#{remote}.yml"
      diff = HashDiff.diff(live, cached)
    end     

    def write_yaml(file, obj)
      out "writing yaml to: #{file}"
      File.open(file,'w') do |h| 
         h.write obj.to_yaml
      end      
    end

    def gem_dir
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
	end
end