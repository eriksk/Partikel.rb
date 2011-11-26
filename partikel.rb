require 'rubygems'
require 'gosu'

class Particle
	attr_accessor :x, :y, :vx, :vy, :alive, :time, :duration
	
	def initialize
		@x, @y, @vx, @vy, @alive, @time, @duration = 0,0,0,0, false, 0, 100
	end	
end

class ParticleEngine
	
	def initialize window
		@particles = []
		#cache 600 particles
		600.times{@particles.push(Particle.new)}		
		#only use one texture for all particles
		@texture = Gosu::Image.new(window, "gfx/particle.png", true)
	end
	
	def spawn
		spawned = 0
		i = 0
		while
			p = @particles[i]
			if !p.alive
				p.alive = true
				p.time = 0
				p.x = 800/2
				p.y = 500
				p.vx = -1.0 + rand() * 2.0
				p.vy = -12.0 + rand() * 8.0
				p.duration = 1 + rand(400)
				spawned += 1
			end
			break if (i -1 >= @particles.length)
			#spawn a maximum of 2 particles at a time
			break if spawned > 2
			i += 1
		end
	end
	
	def count
		count = 0
		@particles.each{|p| 
			if p.alive
				count += 1
			end
		}
		count
	end
	
	#linear interpolation
	def lerp(x, y, t)
		x + (y - x) * t
	end
	
	def update
		@particles.each{|p|
			if p.alive
				#fake gravity
				p.vy += 0.1
				#interpolate velocity
				p.x += lerp(p.vx, 0, p.time / p.duration) 
				p.y += lerp(p.vy, 0, p.time / p.duration)
				#kill of dead particles
				p.time += 1
				if p.time > p.duration
					p.time = 0
					p.alive = false
				end
			end}
	end
	
	def draw
		@particles.each{|p| 
			if p.alive
				@texture.draw(p.x, p.y, 0)
			end
		}
	end
end

class Partikel < Gosu::Window

	def initialize
		super(800, 600, false)
		@pEng = ParticleEngine.new self
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)	
	end
	
	def update
		@pEng.update
		
		if button_down?(Gosu::KbSpace)
			@pEng.spawn
		end
	end
	
	def draw
		@pEng.draw
		@font.draw("Press space to spawn particles.", 10, 10, 0, 1.0, 1.0, 0xffffffff) 
		@font.draw("Particles: #{@pEng.count}", 10, 30, 0, 1.0, 1.0, 0xffffffff) 
	end
end

#entry point
window = Partikel.new
window.show