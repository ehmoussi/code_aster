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

subroutine axacti(basmod, numa, nbdiam, lisnu, nblis,&
                  nbacti)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 11/03/91
!-----------------------------------------------------------------------
!  BUT:    < AXE ACTIVITE >
!
!   SUBROUTINE SPECIFIQUE AU CALCUL CYCLIQUE
!
!  PERMET DE DETERMINER LES DDL GENERALISE D'INTERFACE AXE A
!  ASSEMBLE CELON LE NOMBRE DE DIAMETRES MODAUX AINSI QUE LA LISTE
!  DES NUMERO DE DDL AXE CORRESPONDANT (NON PAS NUMERO DANS LA LISTE
!  TOTALE DES DDL GENERALISES MAIS DANS LA LISTE DES DDL AXE)
!
!  SI LA LISTE EN ENTREE EST SOUS DIMENSIONNER ON EN TIENT COMPTE
!
!-----------------------------------------------------------------------
!
! BASMOD   /I/: NOM UTLISATEUR DE LA BASE MODALE
! NUMA     /I/: NUMERO DE L'INTERFACE DEFINISSANT LES POINTS DE L'AXE
! NBDIAM   /I/: NOMBRE DE DIAMETRE MODAUX
! LISNU    /O/: LISTE DES NUMERO DES DL A ASSEMBLER
! NBLIS    /I/: DIMENSION DE LA LISTE EN ENTREE
! NBACTI   /O/: NOMBRE DE DDL AXE A ASSENBLER
!
!
!
!
!
!      NTA EST LE NOMBRE DE CMP TRAITEE EN CYCLIQUE
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
!-----------------------------------------------------------------------
    integer :: i, icomp, inu, j, lldesc, llnoa
    integer :: nbacti, nbcmp, nbcpmx, nbdiam, nbec, nblis
    integer :: nbnoa, nbnot, numa
!-----------------------------------------------------------------------
    parameter (nbcpmx=300)
    character(len=8) :: basmod, intf
    aster_logical :: okass
    integer :: idec(nbcpmx), lisnu(nblis)
!
!-----------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
!
!
!-------------------RECUPERATION DE LA LISTE-INTERFACE------------------
!
    call jemarq()
    call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=intf)
!
!----------------RECUPERATION DU NOMBRE D'ENTIERS CODES-----------------
!
    call dismoi('NB_CMP_MAX', intf, 'INTERF_DYNA', repi=nbcmp)
    call dismoi('NB_EC', intf, 'INTERF_DYNA', repi=nbec)
    if (nbec .gt. 10) then
        call utmess('F', 'MODELISA_94')
    endif
!
!-------------------REQUETTE DESCRIPTEUR DES DEFORMEES STATIQUES--------
!
    call jeveuo(intf//'.IDC_DEFO', 'L', lldesc)
    call jelira(intf//'.IDC_DEFO', 'LONMAX', nbnot)
!**************************************************************
    nbnot = nbnot/(2+nbec)
!      NBNOT=NBNOT/3
!**************************************************************
!
!
!
!---------------REQUETTE SUR DEFINITION INTEFACES AXE-------------------
!
    call jeveuo(jexnum(intf//'.IDC_LINO', numa), 'L', llnoa)
!
    call jelira(jexnum(intf//'.IDC_LINO', numa), 'LONMAX', nbnoa)
!
!--------------------------ON DETERMINE LA LISTE------------------------
!
    icomp=0
    nbacti=0
!
    do i = 1, nbnoa
        inu=zi(llnoa+i-1)
!*************************************************************
!        ICOD=ZI(LLDESC+2*NBNOT+INU-1)
        call isdeco(zi(lldesc+2*nbnot+(inu-1)*nbec+1-1), idec, nbcmp)
        do j = 1, nbcmp
!*************************************************************
            okass=.false.
            if (idec(j) .gt. 0) then
                icomp=icomp+1
!-- Cas des diametres 0 et 1 :
!--  En théorie, il n'y a pas besoin de bloquer "artificiellement"
!--  des DDL qui doivent être nuls. On peut laisser le code gérer
!--  tout seul, mais les solutions trouvées sont un peu plus souples.
!--  Les DDL qui doivent être nuls le sont effectivement.
!--  Cependant, pour conserver la non régression, on conserve les blocages
!
!                 okass=.true.
                if (j .eq. 1 .and. nbdiam .eq. 1) okass=.true.
                if (j .eq. 2 .and. nbdiam .eq. 1) okass=.true.
                if (j .eq. 3 .and. nbdiam .eq. 0) okass=.true.
                if (j .eq. 4 .and. nbdiam .eq. 1) okass=.true.
                if (j .eq. 5 .and. nbdiam .eq. 1) okass=.true.
                if (j .eq. 6 .and. nbdiam .eq. 0) okass=.true.
                if (j .eq. 7 .and. nbdiam .eq. 0) okass=.true.
                if (j .eq. 8 .and. nbdiam .eq. 0) okass=.true.
                if (j .eq. 9 .and. nbdiam .eq. 0) okass=.true.
                if (j .eq. 10 .and. nbdiam .eq. 0) okass=.true.
!
            endif
            if (okass) then
                nbacti=nbacti+1
                if (nbacti .le. nblis) lisnu(nbacti)=icomp
            endif
        end do
    end do
!
    call jedema()
end subroutine
