! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmcalm(typmat         , modelz, lischa, ds_material, carele,&
                  ds_constitutive, instam, instap, valinc     , solalg,&
                  optmaz         , base  , meelem, matele)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/meamme.h"
#include "asterfort/mecgme.h"
#include "asterfort/medime.h"
#include "asterfort/memame.h"
#include "asterfort/messtr.h"
#include "asterfort/merige.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmvcex.h"
#include "asterfort/wkvect.h"
!
character(len=*) :: modelz
character(len=*) :: carele
type(NL_DS_Material), intent(in) :: ds_material
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
real(kind=8) :: instam, instap
character(len=19) :: lischa
character(len=6) :: typmat
character(len=*) :: optmaz
character(len=1) :: base
character(len=19) :: meelem(*), solalg(*), valinc(*)
character(len=19) :: matele
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CALCUL DES MATRICES ELEMENTAIRES
!
! ----------------------------------------------------------------------
!
! IN  MODELE : NOM DU MODELE
! IN  LISCHA : LISTE DES CHARGEMENTS
! In  ds_material      : datastructure for material parameters
! In  ds_contact       : datastructure for contact management
! In  ds_constitutive  : datastructure for constitutive laws management
! In  list_func_acti   : list of active functionnalities
! IN  TYPMAT : TYPE DE MATRICE A CALCULER
!                MERIGI  - MATRICE POUR RIGIDITE
!                MEDIRI  - MATRICE POUR CL DIRICHLET LAGRANGE
!                MEGEOM  - MATRICE POUR NON-LIN. GEOMETRIQUE
!                MEAMOR  - MATRICE POUR AMORTISSEMENT
!                MEMASS  - MATRICE POUR MASSE
!                MESUIV  - MATRICE POUR CHARGEMENT SUIVEUR
!                MESSTR  - MATRICE POUR SOUS-STRUCTURES
!                MEELTC  - MATRICE POUR ELTS DE CONTACT
!                MEELTF  - MATRICE POUR ELTS DE FROTTEMENT
! IN  OPTCAL : OPTION DE CALCUL DU MATR_ELEM
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
! IN  OPTMAT : OPTION DE CALCUL POUR LA MATRICE
! OUT MATELE : MATRICE ELEMENTAIRE
! In  l_xthm           : contact with THM and XFEM (!)
!
!
    character(len=19) :: memass, merigi
    character(len=24) :: model
    integer :: jinfc, jchar, jchar2
    integer :: nbchar
    integer :: i
    character(len=16) :: optmat
    character(len=19) :: disp_prev, sigplu, vite_curr, vite_prev, acce_prev, strplu
    character(len=19) :: disp_cumu_inst, disp_newt_curr, varplu, time_curr
    character(len=19) :: varc_prev, varc_curr, time_prev
    character(len=24) :: charge, infoch
    character(len=8) :: mesh
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    optmat = optmaz
    model = modelz
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
!
! --- DECOMPACTION DES VARIABLES CHAPEAUX
!
    if (valinc(1)(1:1) .ne. ' ') then
        call nmchex(valinc, 'VALINC', 'DEPMOI', disp_prev)
        call nmchex(valinc, 'VALINC', 'VITMOI', vite_prev)
        call nmchex(valinc, 'VALINC', 'ACCMOI', acce_prev)
        call nmchex(valinc, 'VALINC', 'VITPLU', vite_curr)
        call nmchex(valinc, 'VALINC', 'SIGPLU', sigplu)
        call nmchex(valinc, 'VALINC', 'STRPLU', strplu)
        call nmchex(valinc, 'VALINC', 'VARMOI', varplu)
        call nmchex(valinc, 'VALINC', 'COMMOI', varc_prev)
        call nmchex(valinc, 'VALINC', 'COMPLU', varc_curr)
        call nmvcex('INST', varc_prev, time_prev)
        call nmvcex('INST', varc_curr, time_curr)
    endif
    if (solalg(1)(1:1) .ne. ' ') then
        call nmchex(solalg, 'SOLALG', 'DEPDEL', disp_cumu_inst)
        call nmchex(solalg, 'SOLALG', 'DDEPLA', disp_newt_curr)
    endif
    if (meelem(1)(1:1) .ne. ' ') then
        call nmchex(meelem, 'MEELEM', 'MERIGI', merigi)
        call nmchex(meelem, 'MEELEM', 'MEMASS', memass)
    endif
!
! --- TRANSFO CHARGEMENTS
!
    charge = lischa(1:19)//'.LCHA'
    infoch = lischa(1:19)//'.INFC'
    call jeveuo(infoch, 'L', jinfc)
    nbchar = zi(jinfc)
    if (nbchar .ne. 0) then
        call jeveuo(charge, 'L', jchar)
        call wkvect('&&NMCALC.LISTE_CHARGE', 'V V K8', nbchar, jchar2)
        do i = 1, nbchar
            zk8(jchar2-1+i) = zk24(jchar-1+i) (1:8)
        end do
    else
        call wkvect('&&NMCALC.LISTE_CHARGE', 'V V K8', 1, jchar2)
    endif
!
    if (typmat .eq. 'MEDIRI') then
!
! --- MATR_ELEM DES CL DE DIRICHLET B
!
        call medime('V', 'ZERO', model, lischa, matele)
!
! --- MATR_ELEM RIGIDITE GEOMETRIQUE
!
    else if (typmat.eq.'MEGEOM') then
        call merige(model(1:8), carele(1:8), sigplu, strplu, matele,&
                    'V', 0, mater=ds_material%field_mate)
!
! --- MATR_ELEM MASSES
!
    else if (typmat.eq.'MEMASS') then
        call memame(optmat, model, ds_material%field_mate,&
                    carele, instam, ds_constitutive%compor, matele,&
                    base)
!
! --- MATR_ELEM AMORTISSEMENT
!
    else if (typmat.eq.'MEAMOR') then
        call meamme(optmat, model, nbchar, zk8(jchar2), ds_material%field_mate,&
                    carele, instam, 'V', merigi,&
                    memass, matele, varplu)
!
! --- MATR_ELEM POUR CHARGES SUIVEUSES
!
    else if (typmat.eq.'MESUIV') then
        call mecgme(model, carele, ds_material%field_mate  , lischa, instap,&
                    disp_prev, disp_cumu_inst, instam, ds_constitutive%compor, matele)
!
! --- MATR_ELEM DES SOUS-STRUCTURES
!
    else if (typmat.eq.'MESSTR') then
        call messtr(base  , optmat, model, carele, ds_material%field_mate,&
                    matele)
    else
        ASSERT(.false.)
    endif
!
! --- MENAGE
!
    call jedetr('&&NMCALC.LISTE_CHARGE')
    call jedema()
!
end subroutine
