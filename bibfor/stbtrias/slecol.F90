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

subroutine slecol(imod, nbmail)
    implicit none
!     =================
!A PRESUPER
!
!     ================================================================
!     !                                                              !
!     !  FONCTION: ECRITURE DES GROUPES DE MAILLES ASSOCIES          !
!     !            AUX COULEURS                                      !
!     !                                                              !
!     ================================================================
!     !                                                              !
!     !  ROUTINES APPELES : CODENT                                   !
!     !                   : CODNOP                                   !
!     !                                                              !
!     !  ROUTINE APPELANTE : PRESUP                                  !
!     !                                                              !
!     ================================================================
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/codnop.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=1) :: prfmai
    character(len=4) :: kbid
    character(len=8) :: chmail, chgrou
    aster_logical :: logiq(256)
    integer :: jpo(256), jnomb(256), jmax(256)
!  ------------ FIN DECLARATION -------------
!
!  -->N  D'UNITE LOGIQUE ASSOCIE AUX FICHIERS
!-----------------------------------------------------------------------
    integer :: i, ic, icmax, icol, imod, inum, ipos
    integer :: j, nbma, nbmail, nbmax, nbtot
    integer, pointer :: maille(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
    prfmai = 'M'
    icmax = 256
    do 10 i = 1, icmax
        logiq(i) = .false.
        jpo(i) = 0
        jnomb(i) = 0
        jmax(i) = 1000
 10 end do
!
    nbmax = 1000
    call jeveuo('&&PRESUP.INFO.MAILLE', 'L', vi=maille)
    do 100 i = 1, nbmail
        inum = maille((i-1)*4+1)
        call codnop(chmail, prfmai, 1, 1)
        call codent(inum, 'G', chmail(2:8))
        icol = maille((i-1)*4+4)
        ipos = icol + 1
        if (ipos .gt. icmax) then
            call utmess('A', 'STBTRIAS_2')
            goto 100
        endif
        if (.not.logiq(ipos)) then
            logiq(ipos)= .true.
            call codent(icol, 'G', kbid)
            call wkvect('&&PRESUP.COUL'//kbid, 'V V K8', nbmax+1, jpo( ipos))
        endif
        nbma = jnomb(ipos)
        nbtot= jmax(ipos)
        if (nbma .ge. nbtot) then
            call codent(icol, 'G', kbid)
            nbtot = nbtot + nbmax
            jmax(ipos) = nbtot
            call juveca('&&PRESUP.COUL'//kbid, nbtot+1)
            call jeveuo('&&PRESUP.COUL'//kbid, 'E', jpo(ipos))
        endif
        jnomb(ipos) = nbma + 1
        zk8(jpo(ipos)-1+nbma+1) = chmail
100 end do
!
! --> ECRITURE DES GROUPES DE MAILLES PAR COULEUR
!
    do 110 ic = 1, icmax
        if (logiq(ic)) then
            call codent((ic-1), 'G', kbid)
            chgrou = 'COUL_'//kbid
            write(imod,'(A,4X,2A)')'GROUP_MA','NOM=',chgrou
            nbma = jnomb(ic)
            write (imod,'(8(2X,A))') (zk8(jpo(ic)-1+j),j=1,nbma)
            write (imod,'(A)') 'FINSF'
            write (imod,'(A)') '%'
            call jedetr('&&PRESUP.COUL'//kbid)
        endif
110 end do
!
    call jedema()
end subroutine
