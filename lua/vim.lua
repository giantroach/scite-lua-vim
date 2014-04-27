-- vim like keybind function
function vim()
    local mode = "insert"
    local lastKc = 0
    local vStartPos = 0

    -- switch to given mode
    function switchTo(nextMode)
        local pos = editor.CurrentPos
        editor:ClearSelections()
        editor:GotoPos(pos)

        mode = nextMode

        if nextMode == "insert" then
            print("-- insert --")

        elseif nextMode == "visual" then
            vStartPos = editor.CurrentPos
            print("-- visual --")
        end

        if editor:AutoCActive() then
            editor:AutoCCancel()
        end

        return true
    end


    -- --------------------------------
    -- OnKey call back starts here
    --
    return function (kc, shift, ctrl, alt, xxx)
        print("kc:" .. kc)
        lastKc = kc


        -- c-[
        if ctrl and kc == 91 then
            switchTo("normal")
            return true
        end


        -- --------------------------------
        -- d mode
        --
        if mode == "d" then
            -- dd
            if kc == 68 then
                editor:LineCut()
                mode = "normal"
                return true
            end

            mode = "normal"
            return true
        end

        -- --------------------------------
        -- normal / visual mode
        --
        if mode == "normal" or mode == "visual" then

            -- --------------------------------
            -- C combination
            --
            if ctrl then
                -- C-f
                if kc == 70 then
                    editor:PageDown()
                    return true
                end

                -- C-b
                if kc == 66 then
                    editor:PageUp()
                    return true
                end

                -- C-g
                if kc == 71 then
                    local path = props["FilePath"]
                    local curLine = editor:LineFromPosition(editor.CurrentPos)
                    local col = editor.Column[editor.CurrentPos]
                    -- TODO: "/private/var/folders/hg/5gfrkr357f76w9k41n4w4dr40000gn/T/tutorhQbCmx" line 28 of 975 --2%-- col 8
                    print("\"" .. path .. "\" line " .. curLine .. " col " .. col)
                    return true
                end

                return true
            end

            -- h
            if kc == 72 then
                if mode == "visual" then
                    editor:CharLeftExtend()
                else
                    editor:CharLeft()
                end
                return true
            end

            -- j
            if kc == 74 then
                if mode == "visual" then
                    editor:LineDownExtend()
                else
                    editor:LineDown()
                end
                return true
            end

            -- k
            if kc == 75 then
                if mode == "visual" then
                    editor:LineUpExtend()
                else
                    editor:LineUp()
                end
                return true
            end

            -- l
            if kc == 76 then
                if mode == "visual" then
                    editor:CharRightExtend()
                else
                    editor:CharRight()
                end
                return true
            end

            -- w
            if kc == 87 then
                if mode == "visual" then
                    editor:WordRightExtend()
                else
                    editor:WordRight()
                end
                return true
            end

            -- e
            if kc == 69 then
                if mode == "visual" then
                    editor:WordRightEndExtend()
                else
                    editor:WordRightEnd()
                end
                return true
            end

            -- b
            if kc == 66 then
                if mode == "visual" then
                    editor:WordLeftExtend()
                else
                    editor:WordLeft()
                end
                return true
            end

            -- $
            if kc == 36 then
                if mode == "visual" then
                    editor:LineEndExtend()
                else
                    editor:LineEnd()
                end
                return true
            end

            -- ^
            if kc == 94 then
                editor:VCHome()
                return true
            end

            -- 0
            if kc == 48 then
                editor:VCHome()
                return true
            end

            -- d
            if kc == 68 then
                mode = "d"
            end

            -- x
            if kc == 88 then
                if mode ~= "visual" then
                    local curLine = editor:LineFromPosition(editor.CurrentPos)
                    local nextCharPos = editor:PositionAfter(editor.CurrentPos)
                    local nextCharLine = editor:LineFromPosition(nextCharPos)

                    if curLine ~= nextCharLine or editor.CurrentPos == nextCharPos then
                        editor:CharLeft()
                    end

                    editor:CharRightExtend()
                end

                editor:Cut()
                return true
            end

            -- y
            if kc == 89 then
                if mode == "visual" then
                    editor:Copy()
                    editor:GotoPos(vStartPos)
                    switchTo("normal")
                end

                return true
            end

            -- p
            if kc == 80 then
                editor:Paste()
                return true
            end


            -- u
            if kc == 85 then
                editor:Undo()
                return true
            end


            -- v
            if kc == 86 then
                switchTo("visual")
                return true
            end

            -- o
            if kc == 79 then
                if mode == "visual" then
                    -- TODO: switch caret pos
                else
                    if shift then
                        editor:GotoLine(editor:LineFromPosition(editor.CurrentPos))
                        editor:NewLine()
                        editor:LineUp()
                    else
                        editor:LineEnd()
                        editor:NewLine()
                    end
                    switchTo("insert")
                end
                return true
            end

            -- go back to sane
            -- As I know SciTE only can use thin caret hence I treated i = a
            if kc == 73 or kc == 65 then -- 73 = i, 65 = a
                switchTo("insert")
                return true
            end

            return true
        end

        return false
    end
end

--add emacs to OnKey array
vim = vim()
addOnkey(vim)
