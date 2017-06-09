/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/* person_in_charge: nicolas.sellenet at edf.fr */
#include "Python.h"

#include "aster_utils.h"

#ifndef _DISABLE_MED
#include "med.h"

/* ---------------------------------------------------------------------- */
static PyObject * aster_nom_ch_med(self, args)
PyObject *self; /* Not used */
PyObject *args;
{
    PyObject *dic_champ_comp = (PyObject*)0;
    PyObject *tupstr;
    char* nomFichierMed;
    int nbChamps;
    char* nomChamp;
    char* nomMaillage;
    char* dtUnit;
    int iChamp;
    int nbComp;
    char* nomsComp;
    char* unitesComp;
    med_idt numFichier = 0;
    med_bool mailLoc;
    med_field_type typeChamp;
    med_int nbCstp;

    if (!PyArg_ParseTuple(args, "s", &nomFichierMed)) return NULL;

    numFichier = MEDfileOpen(nomFichierMed,MED_ACC_RDONLY);
    if ( numFichier <= 0 ) return PyList_New(0);

    nbChamps = (int)MEDnField(numFichier);

    nomChamp = MakeBlankFStr(MED_NAME_SIZE);
    nomMaillage = MakeBlankFStr(MED_NAME_SIZE);
    dtUnit = MakeBlankFStr(MED_NAME_SIZE);
    dic_champ_comp = PyDict_New();
    for (iChamp = 1; iChamp <= nbChamps; ++iChamp) {
        nbComp = (int)MEDfieldnComponent(numFichier,iChamp);
        nomsComp = MakeBlankFStr(nbComp*MED_SNAME_SIZE);
        unitesComp = MakeBlankFStr(nbComp*MED_SNAME_SIZE);

        MEDfieldInfo(numFichier, iChamp, nomChamp, nomMaillage, &mailLoc, &typeChamp,
                     nomsComp, unitesComp, dtUnit, &nbCstp);
        tupstr = MakeTupleString((long)nbComp, nomsComp, (STRING_SIZE)MED_SNAME_SIZE, NULL);

        PyDict_SetItem(dic_champ_comp, PyString_FromString(nomChamp), tupstr);
        FreeStr(nomsComp);
        FreeStr(unitesComp);
    }
    MEDfileClose(numFichier);

    FreeStr(nomChamp);
    FreeStr(nomMaillage);
    FreeStr(dtUnit);

    return dic_champ_comp;
}

static PyMethodDef methods[] = {
    {"get_nom_champ_med", aster_nom_ch_med, METH_VARARGS},
    { NULL, NULL, 0, NULL }
};


#ifndef _WITHOUT_PYMOD_
PyMODINIT_FUNC initmed_aster(void)
{
    Py_InitModule("med_aster", methods);
}
#endif
#endif
