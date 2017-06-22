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

subroutine bmrdda(basmod, intf, nomint, numint, nbddl,&
                  ivddl, nbdif, ord, nliais)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 09/0491/
!-----------------------------------------------------------------------
!  BUT:   < BASE MODALE RANGS DDL ACTIF A INTERFACE>
!
! RENDRE LA LISTE DES RANGS DES  DDL ACTIFS POUR  (DANS
!  UN CONCEPT BASE MODALE) UNE INTERFACE
!  L'INTERFACE EST DONNEE SOIT PAR SON NOM SOIT PAR SON NUMERO
!
!-----------------------------------------------------------------------
!
! BASMOD   /I/: NOM UTILISATEUR DE LA BASE MODALE
! INTF     /I/: NOM UTILISATEUR DE LA LIST_INTEFACE
! NOMINT   /I/: NOM DE L'INTERFACE
! NUMINT   /I/: NUMERO DE L'INTERFACE
! NBDDL    /I/: NOMBRE DE DDL ACTIF ATTENDU
! IVDDL    /O/: LISTE DES RANGS DES DDL
! NBDDL    /M/: NOMBRE ATTENDU - NOMBRE TROUVE
!
!
!
#include "jeveux.h"
#include "asterfort/cheddl.h"
#include "asterfort/codent.h"
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
    integer :: nbcpmx, nbddl, nbdif, numint, i, j, nbec, nbcmp, neq
    integer :: nunoe, iran(1),  ord, nliais, llint3, llint4, llact, llnoe
    integer ::  nbnoe, inoe
    parameter (nbcpmx=300)
    integer :: idec(nbcpmx), ivddl(nbddl)
    character(len=4) :: nliai
    character(len=8) :: basmod, nomint, intf, temp
    character(len=19) :: numddl
    character(len=24) :: noeint, actint, ordol, ordod
    character(len=24) :: valk(2)
    integer, pointer :: deeq(:) => null()
    integer, pointer :: idc_defo(:) => null()
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
!   SI ON A DONNE UNE BASE MODALE
!
    if (basmod(1:1) .ne. ' ') then
!
        call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=intf)
        if (intf .eq. ' ') then
            valk (1) = basmod
            call utmess('F', 'ALGORITH12_30', sk=valk(1))
        endif
!
        call dismoi('NUME_DDL', basmod, 'RESU_DYNA', repk=numddl)
!
!  SI ON A DONNE UNE LIST_INTERFACE
!
    else
        if (intf(1:1) .ne. ' ') then
!
            call dismoi('REF_MASS_PREM', basmod, 'RESU_DYNA', repk=numddl)
!
        else
            valk (1) = basmod
            valk (2) = intf
            call utmess('F', 'ALGORITH12_31', nk=2, valk=valk)
        endif
    endif
!
!--------------RECUPERATION DONNEE GRANDEUR SOUS-JACENTE----------------
!
    call dismoi('NB_CMP_MAX', intf, 'INTERF_DYNA', repi=nbcmp)
    call dismoi('NB_EC', intf, 'INTERF_DYNA', repi=nbec)
!
!----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
!
    if (nomint .ne. '             ') then
        call jenonu(jexnom(intf//'.IDC_NOMS', nomint), numint)
    endif
!
!-----------RECUPERATION DU NOMBRE DE DDL PHYSIQUES ASSEMBLES-----------
!
!
    call dismoi('NB_EQUA', numddl, 'NUME_DDL', repi=neq)
!
!--------------------RECUPERATION DE LA LISTE DDL ACTIF-----------------
!
    actint=intf//'.IDC_DDAC'
    call jeveuo(jexnum(actint, numint), 'L', llact)
!
!----------RECUPERATION DU NOMBRE DE NOEUD DE L' INTERFACES-------------
!
    noeint=intf//'.IDC_LINO'
!
    call jeveuo(jexnum(noeint, numint), 'L', llnoe)
    call jelira(jexnum(noeint, numint), 'LONMAX', nbnoe)
!
!---------------RECUPERATION DU DESCRIPTEUR DES DEFORMEES---------------
!
    call jeveuo(intf//'.IDC_DEFO', 'L', vi=idc_defo)
!
!------------------RECUPERATION ADRESSE DEEQ----------------------------
!
!----ON AJOUT .NUME POUR OBTENIR LE PROF_CHNO
    numddl(15:19)='.NUME'
    call jeveuo(numddl//'.DEEQ', 'L', vi=deeq)
!
!------------------------RECUPERATION DES RANG--------------------------
!
    do i = 1, nbnoe
        if (ord .eq. 0) then
            inoe=zi(llnoe+i-1)
            nunoe=idc_defo(inoe)
            call isdeco(zi(llact+(i-1)*nbec+1-1), idec, nbcmp)
        else
            temp='&&OP0126'
            call codent(nliais, 'D', nliai)
            ordol=temp//'      .LINO.'//nliai
            call jeveuo(ordol, 'L', llint3)
            ordod=temp//'      .LDAC.'//nliai
            call jeveuo(ordod, 'L', llint4)
            inoe=zi(llint3+i-1)
            nunoe=idc_defo(inoe)
            call isdeco(zi(llint4+(i-1)*nbec+1-1), idec, nbcmp)
        endif
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
