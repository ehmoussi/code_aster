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

subroutine cffrot(maf1, koper, maf2, mafrot, numedd)
!
! RESPONSBALE
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/mtcmbl.h"
#include "asterfort/mtdefs.h"
    character(len=1) :: koper
    character(len=19) :: maf1
    character(len=19) :: maf2
    character(len=19) :: mafrot
    character(len=14) :: numedd
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - FROTTEMENT)
!
! CALCUL DE LA MATRICE DE FROTTEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  MAF1   : PARTIE 1 DE LA MATRICE FROTTEMENT
! IN  KOPER  : ADDITION ('+') OU SOUSTRACTION ('-')
! IN  MAF2   : PARTIE 2 DE LA MATRICE FROTTEMENT
! OUT MAFROT : MATRICE GLOBALE TANGENTE AVEC FROTTEMENT RESULTANTE
! OUT NUMEDD : NUME_DDL DE LA MATRICE DE FROTTEMENT
!
!
!
!
    integer :: iret
    real(kind=8) :: coefmu(2)
    character(len=1) :: typcst(2)
    character(len=14) :: numedf, numef1, numef2
    character(len=24) :: limat(2)
! ----------------------------------------------------------------------
!
! --- DESTRUCTION ANCIENNE MATRICE FROTTEMENT
!
    call exisd('MATR_ASSE', mafrot, iret)
    if (iret .ne. 0) then
        call dismoi('NOM_NUME_DDL', mafrot, 'MATR_ASSE', repk=numedf)
        call detrsd('NUME_DDL', numedf)
        call detrsd('MATR_ASSE', mafrot)
    endif
!
! --- PREPARATION COMBINAISON LINEAIRE MAFROT=MAF1-MAF2
!
    limat(1) = maf1
    limat(2) = maf2
    coefmu(1) = 1.0d0
    if (koper .eq. '+') then
        coefmu(2) = +1.0d0
    else if (koper.eq.'-') then
        coefmu(2) = -1.0d0
    else
        ASSERT(.false.)
    endif
    typcst(1) = 'R'
    typcst(2) = 'R'
!
! --- COMBINAISON LINEAIRE MAFROT=MAF1-MAF2
!
    call mtdefs(mafrot, maf1, 'V', 'R')
    call mtcmbl(2, typcst, coefmu, limat, mafrot,&
                ' ', numedd, 'ELIM=')
!
! --- DESTRUCTION DES NUME_DDL
!
    call dismoi('NOM_NUME_DDL', maf1, 'MATR_ASSE', repk=numef1)
    call dismoi('NOM_NUME_DDL', maf2, 'MATR_ASSE', repk=numef2)
    call detrsd('NUME_DDL', numef1)
    call detrsd('NUME_DDL', numef2)
!
! --- DESTRUCTION DES MATRICES DE CONSTRUCTION
!
    call detrsd('MATR_ASSE', maf1)
    call detrsd('MATR_ASSE', maf2)
!
end subroutine
