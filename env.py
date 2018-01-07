import numpy as np
import pyglet


class ArmEnv(object):
   viewer = None
   
   def __init__(self):
       pass

   def step(self, action):
       pass

   def step(self):
       pass

   def render(self):
       if self.viewer is None:
          self.viewer = Viewer()
       self.viewer.render()

class Viewer(pyglet.window.Window):
   def __init__(self):
       pass

   def render(self):
       pass

   def on_draw(self):
       pass

   def _update_arm(self):
       pass

if __name__ == "__main__":
   env = ArmEnv()
   while True:
       env.render()
