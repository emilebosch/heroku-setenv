require 'thor'

module SetEnv
	class Cli < Thor

    desc "version", "Shows version information"
    def version
      puts SetEnv::VERSION
    end

    desc "init", "Sets up your env environment"
    def init

      # create directories

      mkdir "./env/templates"
      heroku_remotes.keys.each { |k|
        d = "./env/remotes/#{k}"
        mkdir d
      }

      # add to .gitingore
      # setup en check for gpg
    end

    desc "reset", "Reset an environment to its defaut settings"
    def reset
    end

    desc "set", "Set [ENV] to [ENV] settings"
    def set
    end

    desc "clobber", "Removes all traces of setenv"
    def clobber
      f.rm_f "./env"
    end

    desc "encrypt", "Encrypt your env variables"
    def encrypt
    end

    desc "decrypt", "Decrypt your env variables"
    def decrypt
    end

    desc "show", "Shows your env variables"
    def show
    end

    private

    def f
      FileUtils
    end

    def mkdir(d)
      puts "creating: #{d}"
      f.mkdir_p d      
    end

    def heroku_remotes
      x =  `git remote -v`
      r = x.scan  /^(.*?)\t.*?heroku\.com\:(.*?)\.git(.*?)\(push\)/
      a = {}
      r.map { |r| a[r[0]] = r[1] }
      a
    end

    def gem_dir
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
	end
end