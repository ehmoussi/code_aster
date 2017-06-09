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

subroutine cbsint(char, noma, ligrmo, fonree)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
!
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
!
! BUT : STOCKAGE DES CHARGES DE DEFORMATIONS INITIALES REPARTIES
!       DANS UNE CARTE ALLOUEE SUR LE LIGREL DU MODELE
!
! ARGUMENTS D'ENTREE:
!      CHAR   : NOM UTILISATEUR DU RESULTAT DE CHARGE
!      LIGRMO : NOM DU LIGREL DE MODELE
!      NOMA   : NOM DU MAILLAGE
!      FONREE : FONC OU REEL
!      PARAM  : NOM DU TROISIEME CHAMP DE LA CARTE (EPSIN)
!      MOTCL  : MOT-CLE FACTEUR
!
!-----------------------------------------------------------------------
!
    integer :: nbfac
    character(len=5) :: param
    integer :: ibid, nchei, ncmp
    character(len=16) :: motclf
    character(len=19) :: carte
    character(len=24) :: chsig
    character(len=8), pointer :: valv(:) => null()
    character(len=8), pointer :: vncmp(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    if (fonree .eq. 'REEL') then
        motclf = 'PRE_SIGM'
        call getfac('PRE_SIGM', nbfac)
!
        if (nbfac .ne. 0) then
            param = 'SIINT'
!
            call getfac('PRE_SIGM', nchei)
!
            carte = char//'.CHME.'//param
!
! ---        MODELE ASSOCIE AU LIGREL DE CHARGE
!
            call alcart('G', carte, noma, 'NEUT_K8')
            call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
            call jeveuo(carte//'.VALV', 'E', vk8=valv)
!
            ncmp = 1
            vncmp(1) = 'Z1'
            call getvid(motclf, 'SIGM', iocc=1, scal=chsig, nbret=ibid)
            valv(1) = chsig
            call nocart(carte, 1, ncmp)
!
        endif
    endif
    call jedema()
end subroutine
