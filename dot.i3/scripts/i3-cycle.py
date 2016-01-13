#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
Limit focus switch to containers within the current workspace.

Accepts direction and cycles in one of them.
"""

from argparse import ArgumentParser

import i3


def lazy(func):
    def inner(*args, **kwargs):
        val = getattr(args[0], "_{}".format(func.__name__), None)
        if not val:
            val = func(*args, **kwargs)
            setattr(args[0], "_{}".format(func.__name__), val)
        return val
    inner.__name__ = func.__name__
    return inner


def indexable(func):

    class Iterator(dict):

        def __init__(self, *args, **kwargs):
            super(Iterator, self).__init__(*args, **kwargs)

            self.ids = [res["id"] for res in self["nodes"]]
            self.cur_res_idx = self.ids.index(self["focus"][0])

        def __iter__(self):
            return self

        def next(self):
            self.cur_res_idx = (self.cur_res_idx + 1) % len(self.ids)
            return self.cur_res_idx


    def inner(*args, **kwargs):
        res = func(*args, **kwargs)
        return Iterator(res)

    return inner


class i3State(object):

    @property
    @lazy
    def workspaces(self):
        return i3.get_workspaces()

    @property
    @lazy
    def workspace_info(self):
        for workspace in self.workspaces:
            if workspace["focused"]:
                return workspace

    @property
    @indexable
    @lazy
    def tree(self):
        return i3.get_tree()

    @property
    @indexable
    @lazy
    def output(self):
        for output in self.tree["nodes"]:
            if output["name"] ==  self.workspace_info["output"]:
                return output

    @property
    @indexable
    @lazy
    def dock(self):
        for dock in self.output["nodes"]:
            if dock["name"] ==  "content":
                return dock

    @property
    @indexable
    @lazy
    def workspace(self):
        for workspace in self.dock["nodes"]:
            if workspace["name"] ==  self.workspace_info["name"]:
                return workspace

    @property
    @indexable
    @lazy
    def window(self):
        for window in self.workspace["nodes"]:
            if window["id"] == self.workspace["focus"][0]:
                return window


def main():
    """
    Entry point
    """

    parser = ArgumentParser()
    parser.add_argument("item",
                        choices=("window", "container", "output"),
                        help="Which container type to cycle")
    args = parser.parse_args()

    state = i3State()

    if args.item == "window":
        i3.focus(con_id=state.workspace["nodes"][state.workspace.next()]["focus"][0])
    elif args.item == "container":
        i3.focus(con_id=state.window["nodes"][state.window.next()]["id"])
    elif args.item == "output":
        # Dirty, to be redone
        it = iter(state.tree)
        while True:
            next_output = state.tree["nodes"][it.next()]
            if next_output["name"] != "__i3":
                break

        next_dock = None
        for dock in next_output["nodes"]:
            if dock["name"] ==  "content":
                next_dock = dock
                break

        next_workspace = None
        for workspace in next_dock["nodes"]:
            if workspace["id"] == next_dock["focus"][0]:
                next_workspace = workspace
                break

        next_window = None
        for window in next_workspace["nodes"]:
            if window["id"] == next_workspace["focus"][0]:
                next_window = window
                break

        next_container = None
        for container in next_window["nodes"]:
            if container["id"] == next_window["focus"][0]:
                next_container = container
                break

        i3.focus(con_id=next_container["id"])

if __name__ == '__main__':
    main()
