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

subroutine bmradi(basmod, intf, nomint, numint, nbddl,&
                  ivddl, nbdif)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 25/04/91/
!-----------------------------------------------------------------------
!  BUT:     < BASE MODALE RANG DDL ASSOCIES AUX DEFORMEES INTERFACE >
!
!    RENDRE UN VECTEUR DONNANT LES RANGS DES DDL ASSOCIES AUX DEFORMEES
!   CORRESPONDANT A UNE INTERFACE ( DEFINIE DANS UN CONCEPT DE BASE
!   MODALE) DANS UN CONCEPT BASE MODALE) ASSOCIEES AU DDL D'UNE
!    INTERFACE
!  L'INTERFACE EST DONNEE SOIT PAR SON NOM SOIT PAR SON NUMERO
!
! ARRET AVEC MESSAGE SI DIMENSION EN ENTREE DU VECTEUR EST INSUFFISANTE
! RENVOI LE NOMBRE DE DDL TROUVES SI CELUI CI EST PLUS PETIT QUE CELUI
!  DONNE EN ENTREE
!-----------------------------------------------------------------------
!
! BASMOD   /I/: NOM UTILISATEUR DE LA BASE MODALE OU BLANC
! INTF   /I/: NOM UTILISATEUR DE LA LISTE INTERFACE  OU BLANC
! NOMINT   /I/: NOM DE L'INTERFACE
! NUMINT   /I/: NUMERO DE L'INTERFACE
! NBDDL    /I/: NOMBRE DE RANGS ATTENDUS
! IVDDL    /I/: VECTEUR DES RANGS DES DDL
! NBDIF    /O/: NOMBRE ATTENDU - NOMBRE TROUVE
!
!
!
#include "jeveux.h"
#include "asterfort/cheddl.h"
#include "asterfort/dismoi.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
!
!
!-----------------------------------------------------------------------
    integer :: i, inoe, iran(1), j,  lldes
    integer :: llnoe, nbcmp, nbcpmx, nbddl, nbdif, nbec
    integer :: nbnoe, nbnot, neq, numint, nunoe
!-----------------------------------------------------------------------
    parameter (nbcpmx=300)
    character(len=8) :: basmod, nomint, intf
    character(len=19) :: numddl
    character(len=24) :: noeint
    character(len=24) :: valk(2)
    integer :: ivddl(nbddl), idec(nbcpmx)
    integer :: vali
    integer, pointer :: deeq(:) => null()
!
!-----------------------------------------------------------------------
!
!
    call jemarq()
    nbdif=nbddl
!
!---------------RECUPERATION INTERF_DYNA ET NUME_DDL-----------------
!                 SI DONNEE BASE MODALE OU INTERF_DYNA
!
    if (basmod(1:1) .ne. ' ') then
!
        call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=intf, arret='C')
        if (intf .eq. ' ') then
            valk (1) = basmod
            call utmess('F', 'ALGORITH12_30', sk=valk(1))
        endif
        call dismoi('NUME_DDL', basmod, 'RESU_DYNA', repk=numddl)
    else
        if (intf(1:1) .ne. ' ') then
            call dismoi('NUME_DDL', basmod, 'RESU_DYNA', repk=numddl)
        else
            valk (1) = basmod
            valk (2) = intf
            call utmess('F', 'ALGORITH12_31', nk=2, valk=valk)
        endif
    endif
!
!
!
!------------RECUPERATION DONNEE GRANDEUR SOUS-JACENTE------------------
!
    call dismoi('NB_CMP_MAX', intf, 'INTERF_DYNA', repi=nbcmp)
    call dismoi('NB_EC', intf, 'INTERF_DYNA', repi=nbec)
!
!----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
!
    if (numint .lt. 1) then
        if (nomint .eq. '          ') then
            valk (1) = nomint
            vali = numint
            call utmess('F', 'ALGORITH12_29', sk=valk(1), si=vali)
        else
            call jenonu(jexnom(intf//'.IDC_NOMS', nomint), numint)
        endif
    endif
!
!
!-----------RECUPERATION DU NOMBRE DE DDL PHYSIQUES ASSEMBLES-----------
!
!
    call dismoi('NB_EQUA', numddl, 'NUME_DDL', repi=neq)
!
!
!------------RECUPERATION DU NOMBRE DE NOEUD DE L'INTERFACES------------
!
    noeint=intf//'.IDC_LINO'
!
    call jelira(jexnum(noeint, numint), 'LONMAX', nbnoe)
    call jeveuo(jexnum(noeint, numint), 'L', llnoe)
!
!
!-------------RECUPERATION DU DESCRIPTEUR DES DEFORMEES-----------------
!
    call jeveuo(intf//'.IDC_DEFO', 'L', lldes)
    call jelira(intf//'.IDC_DEFO', 'LONMAX', nbnot)
    nbnot = nbnot/(2+nbec)
!
!----------------RECUPERATION ADRESSE DEEQ------------------------------
!
!----ON AJOUT .NUME POUR OBTENIR LE PROF_CHNO
    numddl(15:19)='.NUME'
    call jeveuo(numddl//'.DEEQ', 'L', vi=deeq)
!
!------RECUPERATION DES NUMERO ORDRE DEFORMEES (COLONNES)---------------
!-----ET RANGS DES DDL D'INTERFACE (LIGNES) DANS VECTEUR ASSEMBLE-------
!
! RECUPERATION RANG DDL
!
    do i = 1, nbnoe
        inoe=zi(llnoe+i-1)
        nunoe=zi(lldes+inoe-1)
        call isdeco(zi(lldes+2*nbnot+(inoe-1)*nbec+1-1), idec, nbcmp)
        do j = 1, nbcmp
            if (idec(j) .gt. 0) then
                nbdif=nbdif-1
                if (nbdif .ge. 0) then
                    call cheddl(deeq, neq, nunoe, j, iran,&
                                1)
                    ivddl(nbddl-nbdif)=iran(1)
                endif
            endif
        end do
    end do
!
    nbdif=-nbdif
!
    call jedema()
end subroutine
