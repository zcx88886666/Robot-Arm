[1mdiff --git a/env.py b/env.py[m
[1mindex 6772658..b41d375 100644[m
[1m--- a/env.py[m
[1m+++ b/env.py[m
[36m@@ -4,44 +4,63 @@[m [mimport pyglet[m
 [m
 class ArmEnv(object):[m
     viewer = None[m
[31m-    dt = 0.1    # refresh rate[m
[32m+[m[32m    dt = .1    # refresh rate[m
     action_bound = [-1, 1][m
     goal = {'x': 100., 'y': 100., 'l': 40}[m
[31m-    state_dim = 2[m
[32m+[m[32m    state_dim = 9[m
     action_dim = 2[m
 [m
     def __init__(self):[m
         self.arm_info = np.zeros([m
             2, dtype=[('l', np.float32), ('r', np.float32)])[m
[31m-        self.arm_info['l'] = 100[m
[31m-        self.arm_info['r'] = np.pi/6[m
[32m+[m[32m        self.arm_info['l'] = 100        # 2 arms length[m
[32m+[m[32m        self.arm_info['r'] = np.pi/6    # 2 angles information[m
[32m+[m[32m        self.on_goal = 0[m
 [m
     def step(self, action):[m
         done = False[m
[31m-        r = 0.[m
         action = np.clip(action, *self.action_bound)[m
         self.arm_info['r'] += action * self.dt[m
[31m-        self.arm_info['r'] %= np.pi * 2    # normalize  avoid rotation angle to be larger than 360[m
[31m-[m
[31m-        # state[m
[31m-        s = self.arm_info['r'][m
[32m+[m[32m        self.arm_info['r'] %= np.pi * 2    # normalize[m
 [m
         (a1l, a2l) = self.arm_info['l']  # radius, arm length[m
         (a1r, a2r) = self.arm_info['r']  # radian, angle[m
         a1xy = np.array([200., 200.])    # a1 start (x0, y0)[m
         a1xy_ = np.array([np.cos(a1r), np.sin(a1r)]) * a1l + a1xy  # a1 end and a2 start (x1, y1)[m
         finger = np.array([np.cos(a1r + a2r), np.sin(a1r + a2r)]) * a2l + a1xy_  # a2 end (x2, y2)[m
[32m+[m[32m        # normalize features[m
[32m+[m[32m        dist1 = [(self.goal['x'] - a1xy_[0]) / 400, (self.goal['y'] - a1xy_[1]) / 400][m
[32m+[m[32m        dist2 = [(self.goal['x'] - finger[0]) / 400, (self.goal['y'] - finger[1]) / 400][m
[32m+[m[32m        r = -np.sqrt(dist2[0]**2+dist2[1]**2)[m
 [m
         # done and reward[m
         if self.goal['x'] - self.goal['l']/2 < finger[0] < self.goal['x'] + self.goal['l']/2:[m
             if self.goal['y'] - self.goal['l']/2 < finger[1] < self.goal['y'] + self.goal['l']/2:[m
[31m-                done = True[m
[31m-                r = 1.[m
[32m+[m[32m                r += 1.[m
[32m+[m[32m                self.on_goal += 1[m
[32m+[m[32m                if self.on_goal > 50:[m
[32m+[m[32m                    done = True[m
[32m+[m[32m        else:[m
[32m+[m[32m            self.on_goal = 0[m
[32m+[m
[32m+[m[32m        # state[m
[32m+[m[32m        s = np.concatenate((a1xy_/200, finger/200, dist1 + dist2, [1. if self.on_goal else 0.]))[m
         return s, r, done[m
 [m
     def reset(self):[m
         self.arm_info['r'] = 2 * np.pi * np.random.rand(2)[m
[31m-        return self.arm_info['r'][m
[32m+[m[32m        self.on_goal = 0[m
[32m+[m[32m        (a1l, a2l) = self.arm_info['l']  # radius, arm length[m
[32m+[m[32m        (a1r, a2r) = self.arm_info['r']  # radian, angle[m
[32m+[m[32m        a1xy = np.array([200., 200.])  # a1 start (x0, y0)[m
[32m+[m[32m        a1xy_ = np.array([np.cos(a1r), np.sin(a1r)]) * a1l + a1xy  # a1 end and a2 start (x1, y1)[m
[32m+[m[32m        finger = np.array([np.cos(a1r + a2r), np.sin(a1r + a2r)]) * a2l + a1xy_  # a2 end (x2, y2)[m
[32m+[m[32m        # normalize features[m
[32m+[m[32m        dist1 = [(self.goal['x'] - a1xy_[0])/400, (self.goal['y'] - a1xy_[1])/400][m
[32m+[m[32m        dist2 = [(self.goal['x'] - finger[0])/400, (self.goal['y'] - finger[1])/400][m
[32m+[m[32m        # state[m
[32m+[m[32m        s = np.concatenate((a1xy_/200, finger/200, dist1 + dist2, [1. if self.on_goal else 0.]))[m
[32m+[m[32m        return s[m
 [m
     def render(self):[m
         if self.viewer is None:[m
