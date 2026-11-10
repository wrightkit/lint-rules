variables {
    global:
        0: pool
}

rule ("flagged: binder in another binder's per-element argument") {
    event {
        Ongoing - Global;
    }
    actions {
        Set Global Variable(pool, Filtered Array(All Players(Team 1), Is True For Any(Array(Is Alive(Current Array Element)), Current Array Element)));
    }
}

rule ("flagged: binder nested in a condition") {
    event {
        Ongoing - Global;
    }
    conditions {
        Count Of(Mapped Array(All Players(Team 1), Filtered Array(All Players(Team 2), Is Alive(Current Array Element)))) > 0;
    }
}

rule ("clean: binder in the array-source argument") {
    event {
        Ongoing - Global;
    }
    actions {
        Set Global Variable(pool, Filtered Array(Sorted Array(All Players(Team 1), Current Array Index), Is Alive(Current Array Element)));
    }
}

rule ("clean: single binder") {
    event {
        Ongoing - Global;
    }
    actions {
        Set Global Variable(pool, Filtered Array(All Players(Team 1), Is Alive(Current Array Element)));
    }
}
