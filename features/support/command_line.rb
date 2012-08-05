module CommandLine
  COMAND_LINE_OUTPUT_PATH = "#{File.dirname(__FILE__)}/../../#{SCRATCH}/commandline_output.txt"
  module Windows
    def run command
      command = "#{MIRAGE_CMD} #{command.split(' ').drop(1).join(' ')}" if command =~ /^mirage/
      command = "#{command} > #{COMAND_LINE_OUTPUT_PATH}"
      Dir.chdir(SCRATCH) do
        `#{BLANK_RUBYOPT_CMD}`
        process = ChildProcess.build(*(command.split(' ')))
        process.start
        sleep 0.5 until process.exited?
      end
      File.read(COMAND_LINE_OUTPUT_PATH)
    end
  end

  module Linux
    def run command
      Dir.chdir SCRATCH do
        `#{BLANK_RUBYOPT_CMD} && #{command}`
      end
    end
  end

  def normalise text
    text.gsub(/[\n]/, ' ').gsub(/\s+/, ' ')
  end
end

World CommandLine
ChildProcess.windows? ? World(CommandLine::Windows) : World(CommandLine::Linux)