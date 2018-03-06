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
subroutine nmrecz(numedd, ds_contact,&
                  cndiri, cnfint    , cnfext, ddepla,&
                  fonc)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
!
real(kind=8) :: fonc
character(len=24) :: numedd
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19) :: cndiri, cnfint, cnfext, ddepla
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (RECHERCHE LINEAIRE)
!
! CALCUL DE LA FONCTION POUR LA RECHERCHE LINEAIRE
!
! ----------------------------------------------------------------------
!
! IN  NUMEDD : NOM DU NUME_DDL
! In  ds_contact       : datastructure for contact management
! IN  CNDIRI : VECT_ASSE REACTIONS D'APPUI
! IN  CNFINT : VECT_ASSE FORCES INTERIEURES
! IN  CNFEXT : VECT_ASSE FORCES EXTERIEURES
! IN  DDEPLA : INCREMENT DE DEPLACEMENT
! OUT FONC   : VALEUR DE LA FONCTION
!
! ----------------------------------------------------------------------
!
    integer :: ieq, neq
    real(kind=8), pointer :: v_ddepl(:) => null()
    real(kind=8), pointer :: v_diri(:) => null()
    real(kind=8), pointer :: v_fext(:) => null()
    real(kind=8), pointer :: v_fint(:) => null()
    real(kind=8), pointer :: v_cont_disc(:) => null()
!
! ----------------------------------------------------------------------
!
    call dismoi('NB_EQUA', numedd, 'NUME_DDL', repi=neq)
!
    call jeveuo(cnfext(1:19)//'.VALE', 'L', vr=v_fext)
    call jeveuo(cnfint(1:19)//'.VALE', 'L', vr=v_fint)
    call jeveuo(cndiri(1:19)//'.VALE', 'L', vr=v_diri)
    call jeveuo(ddepla(1:19)//'.VALE', 'L', vr=v_ddepl)
!
    fonc = 0.d0
    if (ds_contact%l_cnctdf) then
        call jeveuo(ds_contact%cnctdf(1:19)//'.VALE', 'L', vr=v_cont_disc)
        do ieq = 1, neq
            fonc = fonc + v_ddepl(ieq) * (v_fint(ieq)+ v_diri(ieq) + v_cont_disc(ieq) - v_fext(ieq))
        end do
    else
        do ieq = 1, neq
            fonc = fonc + v_ddepl(ieq) * (v_fint(ieq)+ v_diri(ieq)- v_fext(ieq))
        end do
    endif
!
end subroutine
