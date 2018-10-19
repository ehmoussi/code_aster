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
!
subroutine caraun(sdcont, nzocu , nbgdcu, coefcu,&
                  compcu, multcu, penacu, ntcmp)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/cazouu.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: sdcont
integer, intent(in) :: nzocu
character(len=24), intent(in) :: nbgdcu, coefcu, compcu, multcu, penacu
integer, intent(out) :: ntcmp
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Read informations for LIAISON_UNILATER in command
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! IN  MOTFAC : MOT_CLEF FACTEUR POUR LIAISON UNILATERALE
! IN  NZOCU  : NOMBRE DE ZONES DE LIAISON_UNILATERALE
! IN  NBGDCU : NOM JEVEUX DE LA SD INFOS POINTEURS GRANDEURS
!       ZI(JNBGD+IOCC-1): INDICE DEBUT DANS LISTE DES NOMS DES GRANDEURS
!                       POUR ZONE IOCC
!       ZI(JNBGD+IOCC) - ZI(JNBGD+IOCC-1): NOMBRE DE GRANDEURS DE LA
!                       ZONE IOCC
! IN  COEFCU : NOM JEVEUX DE LA SD CONTENANT LES COEFFICIENTS DES
!              GRANDEURS DE MEMBRE DE DROITE
!              VECTEUR TYPE ZR OU ZK8 SUIVANT FONREE
!       Z*(JCOEF+IOCC-1): VALEUR OU NOM FONCTION DU MEMBRE DE DROITE
! IN  COMPCU : NOM JEVEUX DE LA SD CONTENANT LES GRANDEURS DU MEMBRE
!              DE GAUCHE
!              LONGUEUR = ZI(JDUME+3)
!              INDEXE PAR NBGDCU:
!       ZI(JNBGD+IOCC-1): INDEX DEBUT POUR ZONE IOCC
!       ZI(JDUME+2*(IOCC-1)+5) = ZI(JNBGD+IOCC)-ZI(JNBGD+IOCC-1):
!                         NOMBRE GRANDEURS A GAUCHE POUR ZONE IOCC
!       ZK8(JCMPG-1+INDEX+ICMP-1): NOM ICMP-EME GRANDEUR
! IN  MULTCU : NOM JEVEUX DE LA SD CONTENANT LES COEF DU MEMBRE
!              DE GAUCHE
!              VECTEUR TYPE ZR OU ZK8 SUIVANT FONREE
!              MEME ACCES QUE COMPCU
! IN  PENACU : NOM JEVEUX DE LA SD CONTENANT LES COEF DE PENALITE
!              VECTEUR TYPE ZR, MEME ACCES QUE COEFCU
! OUT NTCMP  : NOMBRE TOTAL DE COMPOSANTES SUR TOUTES LES ZONES
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: zmax = 30
    character(len=8) :: cmpgd(zmax), k8bid, ccoef, ccmult(zmax)
    integer :: noc, nbcmp, nbcmul
    integer :: i_zone, icmp, iform
    character(len=16) :: s_algo_cont, keywf
    real(kind=8) :: pena
    character(len=24) :: sdcont_paraci
    integer, pointer :: v_sdcont_paraci(:) => null()
    real(kind=8), pointer :: v_sdunil_penacu(:) => null()
    character(len=8), pointer :: v_sdunil_coefcu(:) => null()
    integer, pointer :: v_sdunil_nbgdcu(:) => null()
    character(len=8), pointer :: v_sdunil_compcu(:) => null()
    character(len=8), pointer :: v_sdunil_multcu(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    iform       = 4
    keywf       = 'ZONE'
    ntcmp       = 0
!
! - Datastructure for contact definition
!
    sdcont_paraci = sdcont(1:8)//'.PARACI'
    call jeveuo(sdcont_paraci, 'E', vi=v_sdcont_paraci)
!
! - Set the formulation
!
    v_sdcont_paraci(4) = iform
!
! - Get algorithm
!
    call cazouu(keywf, nzocu, 'ALGO_CONT', 'T')
    call getvtx(keywf, 'ALGO_CONT', iocc=1, scal=s_algo_cont)
    if (s_algo_cont .eq. 'CONTRAINTE') then
        v_sdcont_paraci(30) = 1
    else if (s_algo_cont .eq. 'PENALISATION') then
        v_sdcont_paraci(30) = 4
        call wkvect(penacu, 'V V R', nzocu, vr = v_sdunil_penacu)
        do i_zone = 1, nzocu
            call getvr8(keywf, 'COEF_PENA', iocc=i_zone, scal=pena)
            v_sdunil_penacu(i_zone) = pena
        enddo
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Parameter
!
    v_sdcont_paraci(3) = 10
!
! - Right-hand side
!
    call wkvect(coefcu, 'V V K8', nzocu, vk8 = v_sdunil_coefcu)
    do i_zone = 1, nzocu
        call getvid(keywf, 'COEF_IMPO', iocc=i_zone, scal=ccoef, nbret=noc)
        v_sdunil_coefcu(i_zone) = ccoef
    end do
!
! - Left-hand side - Count DOF
!
    call wkvect(nbgdcu, 'V V I', nzocu+1, vi = v_sdunil_nbgdcu)
    v_sdunil_nbgdcu(1) = 1
    ntcmp = 0
    do i_zone = 1, nzocu
        call getvtx(keywf, 'NOM_CMP'  , iocc=i_zone, scal=k8bid, nbret=nbcmp)
        call getvid(keywf, 'COEF_MULT', iocc=i_zone, scal=k8bid, nbret=nbcmul)
        if (nbcmp .ne. nbcmul) then
            call utmess('F', 'UNILATER_42')
        endif
        nbcmp  = abs(nbcmp)
        nbcmul = abs(nbcmul)
        ntcmp  = ntcmp + nbcmp
        if (ntcmp .gt. zmax) then
            call utmess('F', 'UNILATER_43')
        endif
        v_sdunil_nbgdcu(i_zone+1) = v_sdunil_nbgdcu(i_zone) + nbcmp
    end do
!
    call wkvect(compcu, 'V V K8', ntcmp, vk8 = v_sdunil_compcu)
    call wkvect(multcu, 'V V K8', ntcmp, vk8 = v_sdunil_multcu)
!
! - Left-hand side - List of parameters
!
    do i_zone = 1, nzocu
        nbcmp = v_sdunil_nbgdcu(i_zone+1) - v_sdunil_nbgdcu(i_zone)
        call getvtx(keywf, 'NOM_CMP', iocc=i_zone, nbval=nbcmp, vect=cmpgd,&
                    nbret=noc)
        call getvid(keywf, 'COEF_MULT', iocc=i_zone, nbval=nbcmp, vect=ccmult,&
                    nbret=noc)
        do icmp = 1, nbcmp
            v_sdunil_compcu(v_sdunil_nbgdcu(i_zone)+icmp-1) = cmpgd(icmp)
            v_sdunil_multcu(v_sdunil_nbgdcu(i_zone)+icmp-1) = ccmult(icmp)
        end do
    end do
!
    call jedema()
!
end subroutine
