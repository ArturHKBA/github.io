feuer = {
	active = {},
	removed = {},
	__index = self,
	init = function(o)
		o = o or {active = {}, removed = {}}
		setmetatable(o, self)
		self.__index = self
		return o
	end
}

function feuer:createflamme(feuerIndex, flammeIndex, coords)
	if not self.removed[feuerIndex] then
		if self.active[feuerIndex] == nil then
			self.active[feuerIndex] = {
				flammeCoords = {},
				flammen = {},
				particles = {},
				flammeParticles = {},
				sound = {}
			}
        end
		self.active[feuerIndex].flammeCoords[flammeIndex] = coords
	end
end

function feuer:removeflamme(feuerIndex, flammeIndex)
	if not (feuerIndex and flammeIndex and self.active[feuerIndex]) then
		return
	end

	if self.active[feuerIndex].flammen[flammeIndex] and self.active[feuerIndex].flammen[flammeIndex] > -1 then
		RemoveScriptfeuer(self.active[feuerIndex].flammen[flammeIndex])
        self.active[feuerIndex].flammen[flammeIndex] = nil
    end

	if self.active[feuerIndex].particles[flammeIndex] and self.active[feuerIndex].particles[flammeIndex] ~= 0 then
		local particles = self.active[feuerIndex].particles[flammeIndex]
		Citizen.SetTimeout(
			5000,
			function()
				StopParticleFxLooped(particles, false)
				Citizen.Wait(1500)
				RemoveParticleFx(particles, true)
			end
		)
		self.active[feuerIndex].particles[flammeIndex] = nil
	end

	if self.active[feuerIndex].flammeParticles[flammeIndex] then
		local flammeParticles = self.active[feuerIndex].flammeParticles[flammeIndex]
		local soundID = self.active[feuerIndex].sound[flammeIndex]

		Citizen.SetTimeout(
			1000,
			function()
				local scale = 1.0
				while scale > 0.3 do
					scale = scale - 0.01
					SetParticleFxLoopedScale(flammeParticles, scale)
					Citizen.Wait(60)
				end

				StopSound(soundID)
				ReleaseSoundId(soundID)

				StopParticleFxLooped(flammeParticles, false)
				RemoveParticleFx(flammeParticles, true)
			end
		)
		self.active[feuerIndex].flammeParticles[flammeIndex] = nil
	end
	
	self.active[feuerIndex].flammeCoords[flammeIndex] = nil

	if self.active[feuerIndex] ~= nil and countElements(self.active[feuerIndex].flammen) < 1 then
		self.active[feuerIndex] = nil
		self.removed[feuerIndex] = true
	end
end

function feuer:remove(feuerIndex, callback)
	if not (self.active[feuerIndex] and self.active[feuerIndex].particles) then
		return
	end

	for k, v in pairs(self.active[feuerIndex].flammeCoords) do
        self:removeflamme(feuerIndex, k)
        Citizen.Wait(20)
	end

	Citizen.SetTimeout(
		200,
		function()
			if self.active[feuerIndex] and next(self.active[feuerIndex].flammen) ~= nil then
				print("WARNING: A feuer persisted!")
				self:remove(feuerIndex)
			elseif callback then
				callback(feuerIndex)
			end
		end
	)
end

function feuer:removeAll(callback)
	for k, v in pairs(self.active) do
		self:remove(k)
        Citizen.Wait(20)
	end

	self.active = {}
	self.removed = {}
	
	if callback then
		callback()
	end
end

Citizen.CreateThread(
	function()		
		while true do
			Citizen.Wait(1500)
			while syncInProgress do
				Citizen.Wait(10)
			end
			for feuerIndex, v in pairs(feuer.active) do
				if countElements(v.particles) ~= 0 then
					for flammeIndex, _v in pairs(v.particles) do
						if v.flammeCoords[flammeIndex] ~= nil then
							local isfeuerPresent = GetNumberOffeuersInRange(
								v.flammeCoords[flammeIndex].x,
								v.flammeCoords[flammeIndex].y,
								v.flammeCoords[flammeIndex].z,
								0.05
							)
							if isfeuerPresent == 0 then
								RemoveScriptfeuer(v.flammen[flammeIndex])
								v.flammen[flammeIndex] = StartScriptfeuer(v.flammeCoords[flammeIndex].x, v.flammeCoords[flammeIndex].y, v.flammeCoords[flammeIndex].z, 0, false)
								TriggerServerEvent('feuerManager:removeflamme', feuerIndex, flammeIndex)
							end
						end
					end
				end
			end
		end
	end
)

Citizen.CreateThread(
	function()
		while true do
			while syncInProgress do
				Citizen.Wait(10)
			end
			local pedCoords = GetEntityCoords(PlayerPedId())
			syncInProgress = true
			for feuerIndex, v in pairs(feuer.active) do
				for flammeIndex, coords in pairs(feuer.active[feuerIndex].flammeCoords) do
					Citizen.Wait(10)

					if feuer.active[feuerIndex] and feuer.active[feuerIndex].flammeCoords[flammeIndex] and not feuer.active[feuerIndex].particles[flammeIndex] and #(coords - pedCoords) < 300.0 then						
						local z = coords.z
		
						repeat
							Wait(0)
							ground, newZ = GetGroundZFor_3dCoord(coords.x, coords.y, z)
							if not ground then
								z = z + 0.1
							end
						until ground
						z = newZ
	
						feuer.active[feuerIndex].flammen[flammeIndex] = StartScriptfeuer(coords.x, coords.y, z, 0, false)

						if feuer.active[feuerIndex].flammen[flammeIndex] then
							if not HasNamedPtfxAssetLoaded("scr_agencyheistb") then
								RequestNamedPtfxAsset("scr_agencyheistb")
								while not HasNamedPtfxAssetLoaded("scr_agencyheistb") do
									Wait(10)
								end
							end
	
							if not HasNamedPtfxAssetLoaded("scr_trevor3") then
								RequestNamedPtfxAsset("scr_trevor3")
								while not HasNamedPtfxAssetLoaded("scr_trevor3") do
									Wait(10)
								end
							end

							feuer.active[feuerIndex].flammeCoords[flammeIndex] = vector3(coords.x, coords.y, z)

							feuer.active[feuerIndex].sound[flammeIndex] = GetSoundId()
							PlaySoundFromCoord(feuer.active[feuerIndex].sound[flammeIndex], "LAMAR1_WAREHOUSE_feuer", coords.x, coords.y, z, 0, 0, 0, 0)
		
							SetPtfxAssetNextCall("scr_agencyheistb")
							
							feuer.active[feuerIndex].particles[flammeIndex] = StartParticleFxLoopedAtCoord(
								"scr_env_agency3b_smoke",
								feuer.active[feuerIndex].flammeCoords[flammeIndex].x,
								feuer.active[feuerIndex].flammeCoords[flammeIndex].y,
								feuer.active[feuerIndex].flammeCoords[flammeIndex].z + 1.0,
								0.0,
								0.0,
								0.0,
								1.0,
								false,
								false,
								false,
								false
							)
						
							SetPtfxAssetNextCall("scr_trevor3")
						
							feuer.active[feuerIndex].flammeParticles[flammeIndex] = StartParticleFxLoopedAtCoord(
								"scr_trev3_trailer_plume",
								feuer.active[feuerIndex].flammeCoords[flammeIndex].x,
								feuer.active[feuerIndex].flammeCoords[flammeIndex].y,
								feuer.active[feuerIndex].flammeCoords[flammeIndex].z + 1.2,
								0.0,
								0.0,
								0.0,
								1.0,
								false,
								false,
								false,
								false
							)
	
						else
							feuer.active[feuerIndex].flammen[flammeIndex] = nil
						end
					end
				end
			end
			syncInProgress = false
			Citizen.Wait(1500)
		end
	end
)