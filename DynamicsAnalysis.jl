# TODO
# - Add in Weave.jl documentation - that shit is mad dope

using Plots;
using Statistics;

println("\33[2J"); # Clear the terminal


# Define all the constants / vectors / function variables
atm = 101.3e3; # Pa = 1 atmosphere
g = 9.8; # m / s^2, gravitational constant on Earth's surface
m = 1500; # 1000 kg vehicle
Px = 2*g*m # pushing from SpaceX pusher
a_acc = Px / m;
Pub = 0; # Propulsion from UB team system
B = 0; # Braking force - solve for that later

μ = 0; # Friction constant - not sure what that is either
f = 0; # Friction force - solve later
Cd = .2; # Coefficient of drag
SA = .05; # m^2, surface area exposed to -V vector
D = (ρ, v) -> Cd .* SA .* (1/2) .* ρ .* v.^2; # Drag function
percent_safety = .1; # Safety factor of track length
vmax = 150; # m/s, top speed we're trying to reach
d_TOT = 1.25e3; # m, total length of track
v_CO = 3; # m/s, speed which for cool off speed at end

# Start calculating things
d_ACO = vmax.^2 ./ (2*a_acc) # Distance to ACO
d_BRAKE = (1-percent_safety)*d_TOT - d_ACO; # Distance from BO to BCO
a_BRAKE = (vmax^2 - v_CO^2)/(2*d_BRAKE);
t_BRAKING = (vmax - v_CO)/a_BRAKE;

# Define a sinusoidal atmosphere
xs = 0:1:d_TOT;
maxp = 0; # Worst case
atmosphere_profile = map(x -> abs(maxp*atm*sin(4*L*x/(2*pi))), xs); # 4 cycle per L
atmos_avg = mean(atmosphere_profile);

# Taking real part of sqrt of complex creates the following behavior
# B = B if B > 0
# B = 0 if B < 0
B = real(sqrt(Complex(m*a_BRAKE - D(.01*atmos_avg, vmax/2) - μ*m*g))).^2;

plot(bg=:black);
plt = plot!(xs, atmosphere_profile/atm,linewidth=2,title="Pressure Profile")

println("Mass of Vehicle: $(round(m)) kg")
println("Breaking Force Needed: $(round(B/1000)) kN")
println("Breaking Time: $(round(t_BRAKING)) s")
println("Propulsion: $(round(Px/1000)) kN")
println("Max Speed: $(round(vmax*2.23694)) mph")
println("Distance Spent Braking: $(round(d_BRAKE)) m")
println("Distance Spent Accelerating: $(round(d_ACO)) m")
