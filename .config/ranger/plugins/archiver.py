import subprocess
from ranger.api.commands import Command


class hello_compress(Command):

    archived_file_name = ""
    to_compress_files_list = []


    def execute(self):
        # archive
        if not self.arg(1) or not self.self.arg(2):
            return self.fm.notify("Missing archived file name! Usage :compress archived_file_name <files>", bad=True)

        self.archived_file_name = self.arg(1)

        for i in range(2, 1000):
            if not self.arg(i):
                break
            self.to_compress_files_list.append(self.arg(i))

        command = ["arc", "archive"]
        command.append(self.archived_file_name)
        command.append(self.to_compress_files_list)

        subprocess.run(command)
        return self.fm.notify("Successfully compressed files!")
