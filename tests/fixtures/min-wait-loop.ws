variables {
    global:
        0: index
}

rule ("flagged: While waits at the minimum rate") {
    event {
        Ongoing - Global;
    }
    actions {
        While(True);
            Wait(0.016, Ignore Condition);
        End;
    }
}

rule ("flagged: For Global Variable waits below the minimum rate") {
    event {
        Ongoing - Global;
    }
    actions {
        For Global Variable(index, 0, 3, 1);
            Wait(0, Ignore Condition);
        End;
    }
}

rule ("flagged: For Player Variable waits at the minimum rate") {
    event {
        Ongoing - Each Player;
        All;
        All;
    }
    actions {
        For Player Variable(Event Player, index, 0, 3, 1);
            Wait(0.016, Ignore Condition);
        End;
    }
}

rule ("clean: loop waits longer than the minimum") {
    event {
        Ongoing - Global;
    }
    actions {
        While(True);
            Wait(0.5, Ignore Condition);
        End;
    }
}

rule ("clean: minimum wait outside a loop") {
    event {
        Ongoing - Global;
    }
    actions {
        Wait(0.016, Ignore Condition);
    }
}

rule ("clean: wait duration is not static") {
    event {
        Ongoing - Global;
    }
    actions {
        While(True);
            Wait(Global.index, Ignore Condition);
        End;
    }
}
