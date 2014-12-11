require 'thor'
require 'YAML'

module SetEnv
	class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts SetEnv::VERSION
    end

    desc "init", "Sets up your env environment"
    def init

      # create directories
      mkdir "./env/services"
      heroku_remotes.keys.each { |k|
        d = "./env/.remotes/#{k}"
        mkdir d
      }

      # add to .gitingore
      # setup en check for gpg
    end

    desc "config", "Get the current settings"
    option :remote
    def config(remote)
      puts heroku_command("config", remote)
    end

    desc "reset [REMOTE]", "Reset an REMOTE to its DEFAULT settings"
    def reset
    end

    desc "set [REMOTE] [SERIVCE] [ENV]", "Set [remote] to [environment] settings"
    def set
    end

    desc "add [SERVICE] [KEY=VAL]..", "Add a service "
    def add(service)
      puts
    end

    desc "clobber", "Removes all traces of setenv"
    def clobber
      f.rm_rf "./env"
    end

    desc "encrypt", "Encrypt your env variables"
    def encrypt
      `tar cvz -f env.tgz ./env && gpg -c env.tgz && rm -rf env.tgz && rm -rf ./env`
    end

    desc "decrypt", "Decrypt your env variables"
    def decrypt
      `gpg env.tgz.gpg && tar -zxvf env.tgz && rm env.tgz`
    end

    desc "show", "Shows your env variables"
    def show
    end

    desc "export", "Export settings"
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

    def write_yaml(file, obj)
      File.open(file,'w') do |h| 
         h.write obj.to_yaml
      end      
    end

    def gem_dir
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
	end
end