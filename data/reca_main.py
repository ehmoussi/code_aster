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

#___________________________________________________________________________
#
#           MODULE DE CALCUL DISTRIBUE POUR MACR_RECAL
#
#  Utilisable en mode EXTERNE, voir les flags avec "python reca_main.py -h"
#___________________________________________________________________________

import glob
import os
import pprint
import sys
from math import sqrt
from optparse import OptionGroup, OptionParser

import numpy as NP

from code_aster.MacroCommands.Recal.recal import (CALC_ERROR, CALCULS_ASTER,
                                                  Affiche_Param,
                                                  Ecriture_Derivees,
                                                  Ecriture_Fonctionnelle)

include_pattern = "# -->INCLUDE<--"
debug = False


if __name__ == '__main__':

    # Execution via YACS ou en externe
    isFromYacs = globals().get('ASTER_ROOT', None)

    # ------------------------------------------------------------------------------------------------------------------
    #                               Execution depuis YACS
    # ------------------------------------------------------------------------------------------------------------------
    if isFromYacs:
        # Execution depuis YACS : les parametres sont deja charges en memoire

        # ----------------------------------------------------------------------------
        # Parametres courant
        X0 = globals().get('X0', [ 80000.,  1000., 30. ])
        dX = globals().get('dX', [ 0.001, 0.001, 0.0001])
        # ----------------------------------------------------------------------------

        # ----------------------------------------------------------------------------
        # Parametres
        os.environ['ASTER_ROOT'] = ASTER_ROOT
        if debug:
            clean = False
            info  = 1
        else:
            clean = True
            info  = 0
        # ----------------------------------------------------------------------------


    # ------------------------------------------------------------------------------------------------------------------
    #                               Execution en mode EXTERNE
    # ------------------------------------------------------------------------------------------------------------------
    else:
        # Execution en mode EXTERNE : on doit depouiller les parametres de la ligne de commande



        p = OptionParser(usage='usage: %s fichier_export [options]' % sys.argv[0])

        # Current estimation
        p.add_option('--input',             action='store',       dest='input',             type='string',                                       help='Chaine de texte contenant les parametres')
        p.add_option('--input_step',        action='store',       dest='input_step',        type='string',                                       help='Chaine de texte contenant les pas de discretisation des differences finies')
        p.add_option('--input_file',        action='store',       dest='input_file',        type='string',   default='input.txt',                help='Fichier contenant les parametres')
        p.add_option('--input_step_file',   action='store',       dest='input_step_file',   type='string',                                       help='Fichier contenant les pas de discretisation des differences finies')

        # Outputs
        p.add_option('--output',            action='store',       dest='output',            type='string',   default='output.txt',               help='fichier contenant la fonctionnelle')
        p.add_option('--output_grad',       action='store',       dest='output_grad',       type='string',   default='grad.txt',                 help='fichier contenant le gradient')

        # Code_Aster installation
        p.add_option('--aster_root',        action='store',       dest='aster_root',        type='string',                                       help="Chemin d'installation d'Aster")
        p.add_option('--as_run',            action='store',       dest='as_run',            type='string',                                       help="Chemin vers as_run")

        # General
        p.add_option('--resudir',           action='store',       dest='resudir',           type='string',                                       help="Chemin par defaut des executions temporaires d'Aster")
        p.add_option("--noclean",           action="store_false", dest="clean",                              default=True,                       help="Erase temporary Code_Aster execution directory")
        p.add_option('--info',              action='store',       dest='info',              type='int',      default=1,                          help="niveau de message (0, [1], 2)")
        p.add_option('--sources_root',      action='store',       dest='SOURCES_ROOT',      type='string',                                       help="Chemin par defaut des surcharges Python")
        # p.add_option('--slave_computation', action='store',       dest='slave_computation', type='string',   default='distrib',                  help="Evaluation de l'esclave ([distrib], include)")

        # MACR_RECAL parameters
        p.add_option('--objective',         action='store',       dest='objective',         type='string',   default='fcalc',                    help="Fonctionnelle ([fcalc]/[error])")
        p.add_option('--objective_type',    action='store',       dest='objective_type',    type='string',   default='vector',                   help="type de la fonctionnelle (float/[vector])")
        p.add_option('--gradient_type',     action='store',       dest='gradient_type',    type='string',   default='no',                       help="calcul du gradient par Aster ([no]/normal/adim)")

        # MACR_RECAL inputs
        p.add_option('--mr_parameters',     action='store',       dest='mr_parameters',     type='string',   default='N_MR_Parameters.py',       help="Fichier de parametres de MACR_RECAL : parametres, calcul, experience")
        p.add_option('--study_parameters',  action='store',       dest='study_parameters',  type='string',                                       help="Fichier de parametre de l'etude : export")
        p.add_option('--parameters',        action='store',       dest='parameters',        type='string',                                       help="Fichier de parametres")

        options, args = p.parse_args()


        # Study : .export file
        if args:
            export =  args[0]
        else:
            liste = glob.glob('*.export')
            export = liste[0]
        if not os.path.isfile(export):
            raise Exception("Export file : is missing!")


        # Code_Aster installation
        ASTER_ROOT = None
        if options.aster_root:
            ASTER_ROOT = options.aster_root
        elif 'ASTER_ROOT' in os.environ:
            ASTER_ROOT = os.environ['ASTER_ROOT']
        if not ASTER_ROOT:
            raise Exception("ASTER_ROOT is missing! Set it by --aster_root flag or environment variable ASTER_ROOT")
        if not os.path.isdir(ASTER_ROOT):
            raise Exception("Wrong directory for ASTER_ROOT : %s" % ASTER_ROOT)
        os.environ['ASTER_ROOT'] = ASTER_ROOT

        if options.as_run:
            as_run = options.as_run
        else:
            as_run = os.path.join(ASTER_ROOT, 'bin', 'as_run')


        # General
        if options.resudir:
            resudir = options.resudir
        clean = options.clean

#         if   options.info == 0: info = False
#         elif options.info == 1: info = False
#         elif options.info == 2: info = True
        info = options.info

        # Import des modules supplementaires
        if options.SOURCES_ROOT:
            if not os.path.isdir(options.SOURCES_ROOT):
                raise Exception("Wrong directory for sources_root : %s" % options.SOURCES_ROOT)
            else:
                sys.path.insert(0, options.SOURCES_ROOT)
                sys.path.insert(0, os.path.join(options.SOURCES_ROOT, 'sources'))


        # MACR_RECAL inputs
        if options.mr_parameters:
            try:
                if info >= 1:
                    print("Read MR parameters file : %s" % options.mr_parameters)
                with open(options.mr_parameters) as f:
                    exec(compile(f.read(), options.mr_parameters, 'exec'))
            except:
                raise Exception("Wrong file for MR Parameters: %s" % options.mr_parameters)
        else:
            raise Exception("MR Parameters file needed ! Use --mr_parameters flag")
        parametres = globals().get('parametres',  None)
        calcul     = globals().get('calcul',      None)
        experience = globals().get('experience',  None)
        poids      = globals().get('poids',       None)

        if not parametres:
            raise Exception("MR Parameters file need to define 'parametres' variable")
        if not calcul:
            raise Exception("MR Parameters file need to define 'calcul' variable")
        if not isinstance(parametres, list):
            raise Exception("Wrong type for 'parametres' variable in MR parameters file : %s"  % options.mr_parameters)
        if not isinstance(calcul, list):
            raise Exception("Wrong type for 'calcul' variable in MR parameters file : %s"      % options.mr_parameters)

        if options.objective == 'error':
            if not isinstance(experience, list):
                raise Exception("For error objective output, the 'experience' variable must be a list of arrays")
            if not isinstance(poids, (list, tuple, NP.ndarray)):
                raise Exception("The 'poids' variable must be a list or an array")
            if len(poids) != len(experience):
                raise Exception("'experience' and 'poids' lists must have the same lenght")


        # MACR_RECAL parameters
        objective      = options.objective
        objective_type = options.objective_type
        gradient_type  = options.gradient_type


        # X0 : read from commandline flag or from file
        if not os.path.isfile(options.input_file):
            options.input_file = None
        if not (options.input or options.input_file):
            raise Exception("Missing input parameters")
        if (options.input and options.input_file):
            raise Exception("Error : please use only one choice for input parameters definition")

        if options.input_file:
            try:
                f = open(options.input_file, 'r')
                options.input = f.read()
                f.close()
            except:
                raise Exception("Can't read input parameters file : %s" % options.input_file)

        # Extract X0 from text
        try:
            txt = options.input.strip()
            txt = txt.replace(',', ' ')
            txt = txt.replace(';', ' ')
            X0 = [ float(x) for x in txt.split() ]
            if not isinstance(X0, list):
                raise Exception("Wrong string for input parameters : %s" % options.input)
        except:
            raise Exception("Can't decode input parameters string : %s.\n It should be a comma separated list." % options.input)


        # dX : read from commandline flag or from file
        dX = None
        if options.gradient_type == 'no':
            if (options.input_step or  options.input_step_file):
                raise Exception("You must set 'gradient_type' to another choice than 'no' or remove input step parameters from commandline")
        else:
            if not (options.input_step or  options.input_step_file):
                raise Exception("Missing input step parameters")
            if (options.input_step and options.input_step_file):
                raise Exception("Error : please use only one choice for input step parameters definition")

            if options.input_step_file:
                try:
                    f = open(options.input_step_file, 'r')
                    options.input_step = f.read()
                    f.close()
                except:
                    raise Exception("Can't read file for discretisation step : %s" % options.input_step_file)

            # Extract dX from text
            try:
                txt = options.input_step.strip()
                txt = txt.replace(',', ' ')
                txt = txt.replace(';', ' ')
                dX = [ float(x) for x in txt.split() ]
                if not isinstance(dX, list):
                    raise Exception("Wrong string for discretisation step : %s" % options.input_step)
            except:
                raise Exception("Can't decode input parameters string : %s.\n It should be a comma separated list." % options.input_step)




    # ------------------------------------------------------------------------------------------------------------------
    #                               Execution des calculs (N+1 calculs distribues si dX est fourni)
    # ------------------------------------------------------------------------------------------------------------------

    # Repertoire contenant les resultats des calculs Aster (None = un rep temp est cree)
    resudir = globals().get('resudir', None)

    # Affichage des parametres
    lpara = [x[0] for x in parametres]
    lpara.sort()
    if info >= 1:
        lpara = [x[0] for x in parametres]
        lpara.sort()
        print("Calcul avec les parametres : \n%s" % Affiche_Param(lpara, X0))

    C = CALCULS_ASTER(
                # MACR_RECAL inputs
                parametres          = parametres,
                calcul              = calcul,
                experience          = experience,
                     )

    fonctionnelle, gradient = C.run(
                # Current estimation
                X0                  = X0,
                dX                  = dX,

                # Code_Aster installation
                ASTER_ROOT          = ASTER_ROOT,
                as_run              = as_run,

                # General
                resudir             = resudir,
                clean               = clean,
                info                = info,

                # Study
                export              = export,

# MACR_RECAL inputs
#                 parametres          = parametres,
#                 calcul              = calcul,
#                 experience          = experience,
    )

    # ------------------------------------------------------------------------------------------------------------------
    #                               Calcul de l'erreur par rapport aux donnees experimentale
    # ------------------------------------------------------------------------------------------------------------------
    if not isFromYacs:        # Execution en mode EXTERNE uniquement

        # Calcul de l'erreur par rapport aux donnees experimentale
        if objective == 'error':
            E = CALC_ERROR(
                experience          = experience,
                X0                  = X0,
                calcul              = calcul,
                poids               = poids,
                objective_type      = objective_type,
                info=info,
            )

            erreur                      = E.CalcError(C.Lcalc)
            erreur, residu, A_nodim, A  = E.CalcSensibilityMatrix(C.Lcalc, X0, dX=dX, pas=None)

            fonctionnelle = erreur
            if   gradient_type == 'normal':
                gradient = A
            elif gradient_type == 'adim':
                gradient = A_nodim
            else:
                raise Exception("??")



    # ------------------------------------------------------------------------------------------------------------------
    #                               Ecriture des resultats
    # ------------------------------------------------------------------------------------------------------------------
    if not isFromYacs:        # Execution en mode EXTERNE uniquement

        # Fonctionnelle
        if options.objective_type == 'float':
            fonctionnelle = sqrt( NP.sum( [x**2 for x in fonctionnelle] ) )
        Ecriture_Fonctionnelle(output_file=options.output, type_fonctionnelle=options.objective_type, fonctionnelle=fonctionnelle)

        # Gradient
        if gradient:
            Ecriture_Derivees(output_file=options.output_grad, derivees=gradient)



    # ------------------------------------------------------------------------------------------------------------------
    #                               Affichages
    # ------------------------------------------------------------------------------------------------------------------
    if info >= 2:
        print("\nFonctionnelle au point X0: \n%s" % str(fonctionnelle))
        if dX:
            print("\nGradient au point X0:")
            pprint.pprint(gradient)
