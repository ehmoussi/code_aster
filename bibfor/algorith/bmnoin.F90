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

subroutine bmnoin(basmdz, intfz, nmintz, numint, nbnoi,&
                  numnoe, nbdif)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    character(len=8) :: intf, nomint, basmod
    character(len=*) :: intfz, nmintz, basmdz
!
!***********************************************************************
!    P. RICHARD     DATE 09/0491/
!-----------------------------------------------------------------------
!  BUT:   < BASE MODALE NOEUDS D'INTERFACE>
!
!   RENDRE LES NUMERO MAILLAGE DES NOEUDS DE L'INTERFACE
!  DANS UNE LIST_INTERFACE OU UNE BASE_MODALE
!
!
!-----------------------------------------------------------------------
!
! BASMDZ   /I/: NOM UTILISATEUR DE LA BASE MODALEE
! INTFZ    /I/: NOM UTILISATEUR DE LA LISTE INTERFACE
! NMINTZ   /I/: NOM DE L'INTERFACE
! NUMINT   /I/: NUMERO DE L'INTERFACE
! NBNOI    /I/: NOMBRE DE NOEUDS ATTENDUS
! NUMNOE   /O/: VECTEUR DES NUMERO DE NOEUDS
! NBDIF    /O/: NOMBRE NOEUDS TROUVES - NOMBRE NOEUDS ATTENDUS
!
!
!
!
!
!
    character(len=24) :: noeint
    character(len=24) :: valk(2)
    integer :: nbnoi, numnoe(nbnoi)
!
!-----------------------------------------------------------------------
!
!
!---------------RECUPERATION INTERF_DYNA ET NUME_DDL-----------------
!                 SI DONNEE BASE MODALE OU INTERF_DYNA
!
!-----------------------------------------------------------------------
    integer :: i, inoe,  llint, nbdif, nbeffi
    integer :: nbnoe, numcou, numint
    integer, pointer :: idc_defo(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    intf = intfz
    nomint = nmintz
    basmod = basmdz
!
    if (basmod(1:1) .ne. ' ') then
!
        call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=intf, arret='C')
        if (intf .eq. '        ') then
            valk (1) = basmod
            call utmess('F', 'ALGORITH12_30', sk=valk(1))
        endif
    else
        if (intf(1:1) .eq. ' ') then
            valk (1) = basmod
            valk (2) = intf
            call utmess('F', 'ALGORITH12_31', nk=2, valk=valk)
        endif
    endif
!
!----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
!
    if (nomint .ne. '             ') then
        call jenonu(jexnom(intf//'.IDC_NOMS', nomint), numint)
    endif
!
!
!----------RECUPERATION DU NOMBRE DE NOEUD DE L' INTERFACES-------------
!
    noeint=intf//'.IDC_LINO'
!
    call jelira(jexnum(noeint, numint), 'LONMAX', nbnoe)
    call jeveuo(jexnum(noeint, numint), 'L', llint)
!
!----------------------TEST SUR NOMBRE DE NOEUDS ATTENDU----------------
!
    if (nbnoi .eq. 0) then
        nbdif=nbnoe
        goto 999
    else
        nbeffi=min(nbnoi,nbnoe)
        nbdif=nbnoi
    endif
!
!------------RECUPERATION DU DESCRIPTEUR DE DEFORMEES-------------------
!
!
    call jeveuo(intf//'.IDC_DEFO', 'L', vi=idc_defo)
!
!------------------------COMPTAGE DES DDL-------------------------------
!
!
!  COMPTAGE
!
    do i = 1, nbeffi
        inoe=zi(llint+i-1)
        numcou=idc_defo(inoe)
        nbdif=nbdif-1
        if (nbdif .ge. 0) numnoe(nbnoi-nbdif)=numcou
    end do
!
    nbdif=-nbdif
!
!
999 continue
    call jedema()
end subroutine
