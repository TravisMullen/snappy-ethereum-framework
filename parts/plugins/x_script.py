import snapcraft
import os
import shutil

class XScriptPlugin(snapcraft.BasePlugin):

    @classmethod
    def schema(cls):
        return {
            '$schema': 'http://json-schema.org/draft-04/schema#',
            'type': 'object',
            'properties': {
                'script': {
                    'type': 'string',
                },
                'destination-dir': {
                    'type': 'string',
                    'default': '',
                },
            },
            'required': [
                'script',
            ]
        }
    
    def build(self):
        if os.path.exists(self.builddir):
            shutil.rmtree(self.builddir)
        os.mkdir(self.builddir)

        print("options.script: {}".format(self.options.script))
        print("CWD: {}".format(os.getcwd()))
        print("src: {}".format(self.sourcedir))
        print("build: {}".format(self.builddir))
        print("installdir: {}".format(self.installdir))

        shutil.copy(
            os.path.join(os.getcwd(), self.options.script),
            self.builddir
        )
        dst = self.installdir
        if self.options.destination_dir:
            dst = os.path.join(self.installdir, self.options.destination_dir)
        # if self.run(['sh', os.path.basename(self.options.script), dst]) != 0:
        #     return False
        return self.run(['sh', os.path.basename(self.options.script), dst]) != 0
        

    def pull(self):
        return
