# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import os
import os.path as osp
import tempfile
from configparser import ConfigParser
from functools import partial
from glob import glob
from subprocess import PIPE, CalledProcessError, Popen, call, check_call

from waflib import Errors, Logs, TaskGen


def _read_config(env, prefs, key):
    """Read a value in the config file and add it in `env` and `prefs`."""
    cfg = ConfigParser()
    cfg.read(osp.join(os.environ["HOME"], ".hgrc"))

    value = cfg.get("aster", key, fallback="")
    dkey = 'PREFS_{}'.format(key.upper())
    env[dkey] = value
    if value:
        prefs[key] = value

def options(self):
    """To get the names of the testcases"""
    group = self.get_option_group("code_aster options")
    group.add_option('-n', '--name', dest='testname',
                     action='append', default=None,
                     help='name of testcases to run (as_run must be in PATH)')
    group.add_option('--outputdir', action='store', default=None, metavar='DIR',
                     help='directory to store the output files. A default '
                          'value can be stored in ~/.hgrc under the section '
                          '"aster"')
    group.add_option('--exectool', dest='exectool',
                     action='store', default=None,
                     help='run a testcase by passing additional arguments '
                          '(possible values are "debugger", "env" + those '
                          'defined in the as_run configuration)')
    group.add_option('--time_limit', dest='time_limit',
                     action='store', default=None,
                     help='override the time limit of the testcase')
    group.add_option('--args', action='append', metavar='ARGS',
                     help="arguments passed to the code_aster executable "
                          "(example: --args=--syntax)")
    group.add_option('--notify', dest='notify',
                     action='store_true', default=False,
                     help='send a desktop notification on completion')

def configure(self):
    """Store developer preferences"""
    self.start_msg('Reading build preferences from ~/.hgrc')
    prefs = {}
    _read_config(self.env, prefs, 'outputdir')
    self.end_msg(prefs)


@TaskGen.feature('test')
def runtest(self):
    """Run a testcase by calling as_run"""
    opts = self.options
    run_aster = osp.join(self.env["BINDIR"], "run_aster")
    if not osp.isfile(run_aster):
        Logs.error("'run_aster' not found, please check your $PATH")
        return
    args = []
    if opts.exectool == 'debugger':
        args.append('--debugger')
    elif opts.exectool == 'env':
        args.append('--run_params=actions=make_env')
    elif opts.exectool is not None:
        args.append('--exectool=%s' % opts.exectool)
    if opts.time_limit:
        args.append('--run_params=time_limit={0}'.format(opts.time_limit))
    if opts.args:
        args.extend(['--run_params=args={0}'.format(arg) for arg in opts.args])
    dtmp = opts.outputdir or self.env['PREFS_OUTPUTDIR'] \
           or tempfile.mkdtemp(prefix='runtest_')
    try:
        os.makedirs(dtmp)
    except (OSError, IOError):
        pass
    Logs.info("destination of output files: %s" % dtmp)
    status = 0
    if not opts.testname:
        raise Errors.WafError('no testcase name provided, use the -n option')
    ASRUN = False
    for test in opts.testname:
        export = test + ".export"
        exp = glob("astest/" + export) + glob("../validation/astest/" + export)
        if not exp:
            raise FileNotFoundError(test + ".export")
        if ASRUN:
            cmd = ['as_run', '--vers=%s' % self.env['ASTERDATADIR'], '--test', test]
        else:
            cmd = [run_aster, "--test"]
        if self.variant == 'debug':
            cmd.extend(['-g'])
        cmd.extend(args)
        if not ASRUN:
            cmd.append(exp[0])
        Logs.info("running %s in '%s'" % (test, self.variant))
        ext = '.' + osp.basename(self.env['PREFIX']) + '.' + self.variant
        out = osp.join(dtmp, osp.basename(test) + ext) + '.output'
        err = osp.join(dtmp, osp.basename(test) + ext) + '.error'
        Logs.info("`- command: %s" % (" ".join(cmd)))
        Logs.info("`- output in %s" % out)
        with open(out, 'w') as fobj, open(err, 'w') as ferr:
            proc = Popen(cmd, stdout=fobj, stderr=ferr, bufsize=1)
        retcode = proc.wait()
        with open(out, 'rb') as fobj:
            btext = fobj.read()
        text = btext.decode("utf8", "replace")
        if 'NOOK_TEST_RESU' in text:
            retcode = 'nook'
        if retcode == 0:
            func = Logs.info
        else:
            func = Logs.error
            status += 1
        func('`- exit %s' % retcode)
        if opts.notify:
            notify('testcase %s ended - exit %s' % (test, retcode),
                   errlevel=retcode)
    if status != 0:
        raise Errors.WafError('testcase failed')


def _has_asrun():
    """check that as_run is available"""
    try:
        check_call(['as_run', '--version'], stdout=PIPE, stderr=PIPE)
    except CalledProcessError:
        return False
    return True

def notify(message, errlevel=0):
    """Send a message as a notification bubble"""
    title = 'codeaster waf'
    d_icon = {
        0 : 'weather-clear',
        'nook' : 'weather-overcast',
        1 : 'weather-storm',
    }
    icon = d_icon.get(errlevel, d_icon[1])
    try:
        call(['notify-send', '-i', icon, title, message])
    except OSError:
        pass
