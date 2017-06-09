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

subroutine mmssfr(defico, izone, posmae, ndexfr)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfmmex.h"
#include "asterfort/cfnumn.h"
#include "asterfort/cfposn.h"
#include "asterfort/iscode.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/mminfi.h"
    character(len=24) :: defico
    integer :: posmae
    integer :: ndexfr(1), izone
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT - UTILITAIRE)
!
! INDICATEUR QU'UNE MAILLE ESCLAVE CONTIENT DES NOEUDS
! EXCLUS PAR SANS_GROUP_NO_FR
!
! ----------------------------------------------------------------------
!
!
! IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
! IN  IZONE  : NUMEOR DE LA ZONE DE CONTACT
! IN  POSMAE : NUMERO DE LA MAILLE ESCLAVE
! OUT ndexfr(1) : ENTIER CODE DES NOEUDS EXCLUS
!
!
!
!
    integer :: numno
    integer :: nnomai, posnno(9), numnno(9)
    integer :: suppok, ino
    integer :: ndimg, ndirex
    integer :: ndexcl(10), nbexfr
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nbexfr = 0
    ndexfr(1) = 0
    do ino = 1, 10
        ndexcl(ino) = 0
    end do
!
! --- NUMEROS DES NOEUDS DE LA MAILLE DANS SD CONTACT
!
    call cfposn(defico, posmae, posnno, nnomai)
    call cfnumn(defico, nnomai, posnno, numnno)
    ASSERT(nnomai.le.9)
!
! --- REPERAGE SI LE NOEUD EST UN NOEUD A EXCLURE
!
    do ino = 1, nnomai
        numno = numnno(ino)
        call cfmmex(defico, 'FROT', izone, numno, suppok)
        if (suppok .eq. 1) then
            nbexfr = nbexfr + 1
            ndexcl(ino) = 1
        else
            ndexcl(ino) = 0
        endif
    end do
!
! --- CODAGE
!
    if (nbexfr .ne. 0) then
!
! ----- NOMBRE DE DIRECTIONS A EXCLURE
!
        ndimg = cfdisi(defico,'NDIM')
        ndirex = mminfi(defico,'EXCL_DIR',izone)
        if (ndimg .eq. 2) then
            if (ndirex .gt. 0) then
                ndexcl(10) = 1
            else
                ASSERT(.false.)
            endif
        else if (ndimg.eq.3) then
            if (ndirex .eq. 1) then
                ndexcl(10) = 0
            else if (ndirex.eq.2) then
                ndexcl(10) = 1
            else
                ASSERT(.false.)
            endif
        else
            ASSERT(.false.)
        endif
        call iscode(ndexcl, ndexfr(1), 10)
    endif
!
    call jedema()
end subroutine
