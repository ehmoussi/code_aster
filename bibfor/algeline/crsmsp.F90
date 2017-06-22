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

subroutine crsmsp(solvbz, matasz, pcpiv, usersmz)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/sdsolv.h"
#include "asterfort/wkvect.h"
    character(len=*) :: solvbz, matasz
    integer          :: pcpiv
    character(len=*) :: usersmz
!-----------------------------------------------------------------------
!     CREATION D'UNE SD SOLVEUR MUMPS SIMPLE PRECISION UTILISEE COMME
!     PRECONDITIONNEUR
!     ATTENTION A LA COHERENCE AVEC CRSVMU ET CRSINT
!-----------------------------------------------------------------------
! IN  K*  SOLVBZ    : NOM DE LA SD SOLVEUR MUMPS BIDON
! IN  K*  MATASZ    : MATRICE DU SYSTEME
! IN  I   PCPIV     : VALEUR DE PCENT_PIVOT
!-----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
    integer :: zslvk, zslvr, zslvi
    integer :: jslvk, jslvr, jslvi, iret
    character(len=19) :: matass, solvbd
    character(len=24) :: usersm
    character(len=8) :: symk
    character(len=3) :: syme
!----------------------------------------------------------------------
    call jemarq()
!
    solvbd = solvbz
    matass = matasz
    usersm = usersmz
! 
    call jeexin(solvbd, iret)
    if (iret .eq. 0) call detrsd('SOLVEUR', solvbd)
!
!     LA MATRICE EST-ELLE NON SYMETRIQUE
    call dismoi('TYPE_MATRICE', matass, 'MATR_ASSE', repk=symk)
    if (symk .eq. 'SYMETRI') then
        syme='OUI'
    else if (symk.eq.'NON_SYM') then
        syme='NON'
    else
        ASSERT(.false.)
    endif
!
    zslvk = sdsolv('ZSLVK')
    zslvr = sdsolv('ZSLVR')
    zslvi = sdsolv('ZSLVI')
    call wkvect(solvbd//'.SLVK', 'V V K24', zslvk, jslvk)
    call wkvect(solvbd//'.SLVR', 'V V R', zslvr, jslvr)
    call wkvect(solvbd//'.SLVI', 'V V I', zslvi, jslvi)
!
!     ATTENTION A LA COHERENCE AVEC CRSVL2 ET CRSVMU
    zk24(jslvk-1+1) = 'MUMPS'
!     PRETRAITEMENTS
    zk24(jslvk-1+2) = 'AUTO'
!     TYPE_RESOL
    if (syme .eq. 'NON') then
        zk24(jslvk-1+3) = 'NONSYM'
    else
        zk24(jslvk-1+3) = 'SYMGEN'
    endif
!     RENUM
    zk24(jslvk-1+4) = 'AUTO'
!     ACCELERATION
    zk24(jslvk-1+5) = 'AUTO'
!     ELIM_LAGR
    zk24(jslvk-1+6) = 'NON'
!     MIXER_PRECISION
    zk24(jslvk-1+7) = 'OUI'
!     PRECONDITIONNEUR
    zk24(jslvk-1+8) = 'OUI'
!     MEMOIRE_MUMPS
    zk24(jslvk-1+9) = usersm
    zk24(jslvk-1+10) = 'XXXX'
    
!     POSTTRAITEMENTS
    zk24(jslvk-1+11) = 'SANS'
    zk24(jslvk-1+12) = 'XXXX'
!
    zr(jslvr-1+1) = -1.d0
    zr(jslvr-1+2) = -1.d0
    zr(jslvr-1+3) = 0.d0
    zr(jslvr-1+4) = 0.d0
!
    zi(jslvi-1+1) = -1
    zi(jslvi-1+2) = pcpiv
    zi(jslvi-1+3) = 0
    zi(jslvi-1+4) = -9999
    zi(jslvi-1+5) = -9999
    zi(jslvi-1+6) = 1
    zi(jslvi-1+7) = -9999
    zi(jslvi-1+8) = 0
!
    call jedema()
end subroutine
