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

subroutine dgfassefibres(nboccasf, iinbgf, tousgroupesnom, tousgroupesnbf, maxmailgrp, &
                         ulnbnoeuds, ulnbmailles, nbfibres2, maxfibre2, ncarfi2, nbocctype1)
!
!
! --------------------------------------------------------------------------------------------------
!
!                O P E R A T E U R    DEFI_GEOM_FIBRE
!
!   Pré-traitement du mot clef ASSEMBLAGE_FIBRE
!
! --------------------------------------------------------------------------------------------------
!
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
!
    integer :: nboccasf, iinbgf, maxmailgrp, ulnbnoeuds, ulnbmailles, nbfibres2, maxfibre2, ncarfi2
    integer :: nbocctype1
    integer           :: tousgroupesnbf(*)
    character(len=24) :: tousgroupesnom(*)
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: ioc, nbfibreass, ibid, ii, jj, nbvfibre
!
    integer           :: vali(3)
    character(len=24) :: valk(3)
!
    character(len=24),pointer ::    nomgrfibreass(:)  => null()
!
! --------------------------------------------------------------------------------------------------
!
    maxfibre2 = 10
    do ioc = 1, nboccasf
        iinbgf = iinbgf + 1
        call getvtx('ASSEMBLAGE_FIBRE', 'GROUP_ASSE_FIBRE', iocc=ioc, scal=tousgroupesnom(iinbgf))
!       Nom des groupes de fibres composant l'assemblage
        call getvtx('ASSEMBLAGE_FIBRE', 'GROUP_FIBRE', iocc=ioc, nbval=0, nbret=nbfibreass)
        nbfibreass = -nbfibreass
        AS_ALLOCATE( size=nbfibreass, vk24 = nomgrfibreass)
        call getvtx('ASSEMBLAGE_FIBRE', 'GROUP_FIBRE', iocc=ioc, &
                    nbval=nbfibreass, vect=nomgrfibreass)
!       Vérification que les groupes existent soit sous SECTION soit sous FIBRE (type1)
        do ii =1 , nbfibreass
            do jj =1 , nbocctype1
                if ( nomgrfibreass(ii) .eq. tousgroupesnom(jj) ) then
                    tousgroupesnbf(iinbgf) = tousgroupesnbf(iinbgf) + tousgroupesnbf(jj)
                    exit
                endif
            enddo
            if ( tousgroupesnbf(iinbgf).eq.0 ) then
                valk(1)=tousgroupesnom(iinbgf)
                valk(2)='GROUP_FIBRE'
                valk(3)= nomgrfibreass(ii)
                call utmess('F', 'MODELISA6_24', nk=3, valk=valk)
            endif
        enddo
        nbvfibre = tousgroupesnbf(iinbgf)
        maxfibre2 = max(maxfibre2,nbvfibre*ncarfi2)
!       Vérification des cardinaux
!           card(GROUP_FIBRE) = card(COOR_GROUP_FIBRE)/2 = card(GX_GROUP_FIBRE)
        call getvr8('ASSEMBLAGE_FIBRE', 'COOR_GROUP_FIBRE', iocc=ioc, nbval=0, nbret=ibid)
        if ( -ibid .ne. 2*nbfibreass ) then
            valk(1)=tousgroupesnom(iinbgf)
            valk(2)='COOR_GROUP_FIBRE'
            vali(1)= -ibid
            vali(2)= 2*nbfibreass
            call utmess('F', 'MODELISA6_23', nk=2, valk=valk, ni=2, vali=vali)
        endif
        call getvr8('ASSEMBLAGE_FIBRE', 'GX_GROUP_FIBRE', iocc=ioc, nbval=0, nbret=ibid)
        if ( -ibid .ne. nbfibreass ) then
            valk(1)=tousgroupesnom(iinbgf)
            valk(2)='GX_GROUP_FIBRE'
            vali(1)= -ibid
            vali(2)= nbfibreass
            call utmess('F', 'MODELISA6_23', nk=2, valk=valk, ni=2, vali=vali)
        endif
        ulnbmailles = ulnbmailles + nbvfibre
        nbfibres2   = nbfibres2   + nbvfibre
        ulnbnoeuds  = ulnbnoeuds  + nbvfibre
        maxmailgrp  = max(maxmailgrp,nbvfibre)
        AS_DEALLOCATE( vk24 = nomgrfibreass )
    enddo
end
