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

subroutine op0011()
    implicit none
!
!
!======================================================================
!
!                       OPERATEUR NUME_DDL
!======================================================================
!
!
!======================================================================
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvr8.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/jedetr.h"
#include "asterfort/numddl.h"
#include "asterfort/numero.h"
#include "asterfort/promor.h"
#include "asterfort/uttcpu.h"
#include "asterfort/wkvect.h"
    integer :: nlimat, imatel
    parameter   (nlimat=100)
    integer :: ifm, nbid, nbmat, niv, nbcha, iacha, il
    character(len=2) :: base
    character(len=8) ::  tlimat(nlimat), nuuti, mo
    character(len=14) :: nudev
    character(len=16) :: type, oper
    character(len=19) :: ch19
    character(len=24) :: list_load
!----------------------------------------------------------------------
    call infmaj()
    call infniv(ifm, niv)
!
    list_load = '&&OP0011.CHARGES   .LCHA'
    base ='GG'
!
! --- RECUPERATION DU CONCEPT RESULTAT ET DE SON NOM UTILISATEUR :
!     ----------------------------------------------------------
    call getres(nuuti, type, oper)
    nudev = nuuti

!
!
! - TRAITEMENT DU MOT CLE MATR_RIGI OU MODELE :
!
    call getvid(' ', 'MATR_RIGI', nbval=0, nbret=nbmat)
!
    if (nbmat .eq. 0) then
        call getvid(' ', 'MODELE', scal=mo, nbret=nbid)
        call getvid(' ', 'CHARGE', nbval=0, nbret=nbcha)
        nbcha = -nbcha
        if (nbcha .ne. 0) then
            call wkvect(list_load, 'V V K24', nbcha, iacha)
            call getvid(' ', 'CHARGE', nbval=nbcha, vect=zk24(iacha), nbret=nbid)
        endif
        call numero(nudev, base,&
                    modelz = mo, list_loadz = list_load)
        call jedetr(list_load)
    else
        nbmat = -nbmat
        call getvid(' ', 'MATR_RIGI', nbval=nbmat, vect=tlimat)
        call wkvect('&&OP001_LIST_MATEL', 'V V K24', nbmat, imatel)
        do il = 1, nbmat
            zk24(imatel+il-1)=tlimat(il)
        end do
!
        call uttcpu('CPU.RESO.1', 'DEBUT', ' ')
        call uttcpu('CPU.RESO.2', 'DEBUT', ' ')
!
! ----- CALCUL DE LA NUMEROTATION PROPREMENT DITE :
!
        call numddl(nudev, 'GG', nbmat, zk24(imatel))
!
! ----- CREATION ET CALCUL DU STOCKAGE MORSE DE LA MATRICE :
!
        call promor(nudev, 'G')
!
        call uttcpu('CPU.RESO.1', 'FIN', ' ')
        call uttcpu('CPU.RESO.2', 'FIN', ' ')

    endif
!
! - Clean
!
    ch19 = nudev
    call jedetr(ch19(1:14)//'.NEWN')
    call jedetr(ch19(1:14)//'.OLDN')
    call jedetr(ch19//'.ADNE')
    call jedetr(ch19//'.ADLI')
end subroutine
