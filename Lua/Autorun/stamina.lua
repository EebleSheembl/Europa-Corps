if CLIENT and Game.IsMultiplayer then return end
local countdown = 60

-- this function works on a good day and sometimes just becomes clunky for no apparent reason
local function LoseStamina(character)

    if countdown > 0 then
        countdown = countdown - 1
        return
    end
    countdown = 60

    if not character.IsHuman then return end

    local characterhealth = character.CharacterHealth

    -- don't deplete stamina if the player can't run
    if not character.AllowInput or not character.CanRun then return end

    -- sometimes i am stupid
    if
        not character.IsKeyDown(InputType.Run)
        or (character.IsKeyDown(InputType.Run)
        and not (
            character.IsKeyDown(InputType.Right)
            or character.IsKeyDown(InputType.Left)
            or character.IsKeyDown(InputType.Up)
            or character.IsKeyDown(InputType.Down)
            )
        )
    then
        return
    end

    local stamina = characterhealth.GetAffliction('stamina')
    if stamina.Strength > 20 then
        stamina.Strength = stamina.Strength - 20
    end
end

if SERVER then
    Hook.Add("think", "EC.ServerStaminaUpdate", function()
        if Game.RoundStarted then
            for client in Client.ClientList do
                LoseStamina(client.Character)
            end
        end
    end)
end

if CLIENT then
    Hook.Add("think", "EC.SingleplayerStaminaUpdate", function()
        if Game.RoundStarted and not Game.Paused then
            LoseStamina(Character.Controlled)
        end
    end)
end