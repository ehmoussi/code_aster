# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# Script permettant de recuperer les etudes ouvertes dans Salome

# un FICHIERS_SORTIE requis dans EXEC_LOGICIEL: OUTPUTFILE1

try:
    import salome
    import SALOMEDS
    import salome_kernel
    orb, lcc, naming_service, cm = salome_kernel.salome_kernel_init()
    # get Study Manager reference
    obj = naming_service.Resolve('myStudyManager')
    myStudyManager = obj._narrow(SALOMEDS.StudyManager)
    List_Studies = myStudyManager.GetOpenStudies()

except Exception, e:
    List_Studies = []
    print "Probleme avec Salome, il n'est peut etre pas lance!"
    print e

try:
    if 'OUTPUTFILE1':
        # On ecrit les etudes ouvertes dans un fichier
        fw = file('OUTPUTFILE1', 'w')
        fw.write('\n'.join(List_Studies))

except Exception, e:
    raise Exception("Erreur : \n%s" % e)

print 62 * '-' + '\n' + '\n'.join(List_Studies) + '\n' + 62 * '-'
