Ns = 15; Ne = 19;
x_p = WienerPredictor(LaV_track2D(Ns:Ne,1)',2)
y_p = WienerPredictor(LaV_track2D(Ns:Ne,2)',2)
z_p = WienerPredictor(LaV_track2D(Ns:Ne,3)',2)
plot3(x_p, y_p, z_p, 'go')
plot3(LaV_track2D(20,1),LaV_track2D(20,2),LaV_track2D(20,3), 'g*')