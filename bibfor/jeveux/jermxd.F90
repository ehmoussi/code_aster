! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

subroutine jermxd(rval, iret)
    implicit none
#include "asterfort/utmess.h"
    real(kind=8) :: rval
    integer :: iret
! person_in_charge: j-pierre.lefebvre at edf.fr
! ----------------------------------------------------------------------
! REDUIT LA VALEUR LIMITE MAXIMUM DE LA MEMOIRE ALLOUEE DYNAMIQUEMENT
! PAR JEVEUX
!
! IN   RVAL : NOUVELLE LIMITE EN OCTETS
!
! OUT  IRET : CODE RETOUR
!             = 0   LA NOUVELLE VALEUR EST PRISE EN COMPTE
!             =/= 0 IL N'A PAS ETE POSSIBLE D'AFFECTER LA
!                   NOUVELLE VALEUR ET ON RENVOIE LA VALEUR DE LA
!                   MEMOIRE OCCUPEE PAR JEVEUX
!
! DEB ------------------------------------------------------------------
    integer :: lbis, lois, lols, lor8, loc8
    common /ienvje/  lbis , lois , lols , lor8 , loc8
    real(kind=8) :: mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio, cuvtrav
    common /r8dyje/ mxdyn, mcdyn, mldyn, vmxdyn, vmet, lgio(2), cuvtrav
! ----------------------------------------------------------------------
    real(kind=8) :: rv(2)
!
    if (rval .le. 0) then
        rv(1)=mcdyn*lois/(1024*1024)
        rv(2)=rval/(1024*1024)
        call utmess('F', 'JEVEUX1_72', nr=2, valr=rv)
    endif
! ON EVALUE LA VALEUR PASSEE EN ARGUMENT PAR RAPPORT A L'OCCUPATION
! TOTALE COURANTE JEVEUX (OBJETS UTILISÉS)
!
    if (mcdyn*lois .lt. rval) then
        vmxdyn = rval/lois
        iret = 0
    else
        iret = max(1, int(mcdyn))
    endif
! FIN ------------------------------------------------------------------
end subroutine
