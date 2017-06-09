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

subroutine pjspma(corres, cham1, cham2, prol0, ligre2,&
                  noca, base, iret)
!
!
! --------------------------------------------------------------------------------------------------
!
!                   Commande PROJ_CHAMP
!
!  Routine "chapeau" : projection aux sous-points
!
!    - appel a pjxxch (usuel pour tous les champs, cf. op0166 ou pjxxpr)
!    - appel a pjcor2 (retour aux sous-points)
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
    character(len=1) :: base
    character(len=8) :: prol0, noca
    character(len=16) :: corres
    character(len=19) :: cham1, cham2, ligre2
    integer :: iret
!
#include "asterfort/assert.h"
#include "asterfort/cescel.h"
#include "asterfort/cnocns.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/pjcor2.h"
#include "asterfort/pjxxch.h"
#include "asterfort/titre.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nncp, ierd
    character(len= 4) :: tycha2
    character(len= 8) :: nompar
    character(len=16) :: option
    character(len=19) :: chauxs, prfchn, cns1, ch2s
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
    call titre()
!   projection du champ sur le maillage masp
    chauxs = '&&PJSPMA'//'.CHAS'
    tycha2 = 'NOEU'
    call pjxxch(corres, cham1, chauxs, tycha2, ' ',&
                prol0, ligre2, base, iret)
    if (iret .ne. 0) goto 999
!
!   chauxs : valeur aux noeud du maillage masp
!   on transforme le CHAM_NO projeté en un CHAM_NO_S
    cns1 = '&&PJSPMA'//'.CH1S'
    call cnocns(chauxs, 'G', cns1)
!
!   cns1 : CHAM_NO_S des valeurs aux noeuds de masp
!   on transpose le champ sur le modèle 2 (ELGA sous-points)
    ch2s = '&&OP0166'//'.CH2S'
    call pjcor2(noca, cns1, ch2s, ligre2, corres,&
                nompar, option, ierd)
!
    ASSERT( (option.eq.'INI_SP_MATER').or.(option.eq.'INI_SP_RIGI') )
!
    call cescel(ch2s, ligre2, option, nompar, prol0,&
                nncp, 'G', cham2, 'A', ierd)
!
    call dismoi('PROF_CHNO', chauxs, 'CHAM_NO', repk=prfchn)
    call detrsd('PROF_CHNO', prfchn)
!
    call detrsd('CHAM_NO_S', cns1)
    call detrsd('CHAM_ELEM_S', ch2s)
!
999 continue
    call detrsd('CHAM_NO', chauxs)
    call jedema()
end subroutine
