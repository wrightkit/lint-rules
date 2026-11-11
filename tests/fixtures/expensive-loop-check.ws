variables {
    global:
        0: index
}

rule ("flagged: Distance Between in a While body") {
    event {
        Ongoing - Global;
    }
    actions {
        While(True);
            Set Global Variable(index, Distance Between(Vector(0, 0, 0), Vector(1, 0, 0)));
            Wait(1, Ignore Condition);
        End;
    }
}

rule ("flagged: Is In Line of Sight nested in a For Player Variable body") {
    event {
        Ongoing - Each Player;
        All;
        All;
    }
    actions {
        For Player Variable(Event Player, index, 0, 3, 1);
            Set Global Variable(index, Add(Is In Line of Sight(Eye Position(Event Player), Vector(0, 0, 0), Barriers Do Not Block LOS), 1));
            Wait(1, Ignore Condition);
        End;
    }
}

rule ("clean: geometry predicate outside a loop") {
    event {
        Ongoing - Global;
    }
    actions {
        Set Global Variable(index, Distance Between(Vector(0, 0, 0), Vector(1, 0, 0)));
    }
}

rule ("clean: geometry predicate only in the loop condition") {
    event {
        Ongoing - Global;
    }
    actions {
        While(Compare(Distance Between(Vector(0, 0, 0), Vector(1, 0, 0)), >, 0));
            Wait(1, Ignore Condition);
        End;
    }
}
