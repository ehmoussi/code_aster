! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine crsvfm(solvbz, matasz, prec, rank, pcpiv, usersmz, blreps, renumz)
!
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
    character        :: prec, rank 
    integer          :: pcpiv
    character(len=*) :: usersmz, renumz
    real(kind=8)     :: blreps
!-----------------------------------------------------------------------
!     CREATION (CR) D'UNE SD SOLVEUR (SV) POUR CALCULER UNE FACTORISATION (F)
!     SIMPLE PRECISION OU LOW-RANK AVEC MUMPS (M)
!     ATTENTION A LA COHERENCE AVEC CRSVMU ET CRSINT
!-----------------------------------------------------------------------
! IN  K*  SOLVBZ    : NOM DE LA SD SOLVEUR MUMPS BIDON
! IN  K*  MATASZ    : MATRICE DU SYSTEME
! IN  K1  PREC      : 'S' ou 'D' (SIMPLE/DOUBLE PRECISION)
! IN  K1  RANK      : 'F' ou 'L' (FULL/LOW RANK)  
! IN  I   PCPIV     : VALEUR DE PCENT_PIVOT
! IN  K*  USERSM    : STRATEGIE MEMOIRE (AUTO/IN_CORE/OUT_OF_CORE)
! IN  R   BLREPS    : VALEUR DU SEUIL POUR UNE FACTO LOW_RANK
!-----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
    integer :: zslvk, zslvr, zslvi
    integer :: jslvk, jslvr, jslvi, iret
    character(len=19) :: matass, solvbd
    character(len=24) :: usersm, renum
    character(len=8) :: symk, kacmum
    character(len=3) :: syme, mixpre
!----------------------------------------------------------------------
    call jemarq()
!
    solvbd = solvbz
    matass = matasz
    usersm = usersmz
    renum = renumz
! 
    call jeexin(solvbd, iret)
    if (iret .eq. 0) call detrsd('SOLVEUR', solvbd)
!
!     LA MATRICE EST-ELLE NON SYMETRIQUE ? 
    call dismoi('TYPE_MATRICE', matass, 'MATR_ASSE', repk=symk)
    if (symk .eq. 'SYMETRI') then
        syme='OUI'
    else if (symk.eq.'NON_SYM') then
        syme='NON'
    else
        ASSERT(.false.)
    endif
! 
    ASSERT((rank == 'L').or.(rank=='F'))
    ASSERT((prec == 'S').or.(prec =='D'))
    if ( rank == 'F' ) then 
        kacmum = 'AUTO'
    elseif ( rank == 'L') then
        kacmum = 'LR+' 
    endif
    if ( prec == 'S' ) then 
        mixpre = 'OUI'
    elseif ( prec == 'D') then
        mixpre ='NON'
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
    zk24(jslvk-1+4) = renum
!     ACCELERATION 
    zk24(jslvk-1+5) = kacmum
!     ELIM_LAGR
    zk24(jslvk-1+6) = 'NON'
!     MIXER_PRECISION
    zk24(jslvk-1+7) = mixpre
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
    zr(jslvr-1+4) = blreps
    zr(jslvr-1+5) = 0.d0
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
