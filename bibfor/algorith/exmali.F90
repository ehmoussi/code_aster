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

subroutine exmali(basmod, nomint, numint, nommat, base,&
                  nblig, nbcol, ord, ii)
!    P. RICHARD     DATE 23/05/91
!-----------------------------------------------------------------------
!  BUT:  < EXTRACTION DES DDL RELATIFS A UNE INTERFACE >
    implicit none
!
!  CONSISTE A EXTRAIRE LES VALEURS DANS LA BASE MODALE DES DDL ACTIFS
!   D'UNE INTERFACE
!
!-----------------------------------------------------------------------
!
! BASMOD   /I/: NOM UT DE LA BASE_MODALE
! NOMINT   /I/: NOM DE L'INTERFACE
! NUMINT   /I/: NUMERO DE L'INTERFACE
! NOMMAT   /I/: NOM K24 DE LA MATRICE RESULTAT A ALLOUE
! BASE     /I/: NOM K1 DE LA BASE POUR CREATION NOMMAT
! NBLIG    /I/: NOMBRE DE LIGNES DE LA MATRICE LIAISON CREE
! NBCOL    /I/: NOMBRE DE COLONNES DE LA MATRICE LIAISON CREE
!
!
!
!
!
#include "jeveux.h"
#include "asterfort/bmrdda.h"
#include "asterfort/dcapno.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
!
    character(len=1) :: base
    character(len=6) :: pgc
    character(len=8) :: basmod, nomint, lintf, kbid
    character(len=24) :: chamva, nommat
    integer :: ord, ii, numint, nbdef, nbcol, ibid, nbddl, nblig, ltrang
    integer :: llcham, iran, iad, i, j, ldmat
!
!-----------------------------------------------------------------------
    data pgc /'EXMALI'/
!-----------------------------------------------------------------------
!
!---------------------RECUPERATION LISTE_INTERFACE AMONT----------------
!
    call jemarq()
!
    call dismoi('REF_INTD_PREM', basmod, 'RESU_DYNA', repk=lintf)
!
!----------------RECUPERATION EVENTUELLE DU NUMERO INTERFACE------------
!
    if (nomint .ne. '             ') then
        call jenonu(jexnom(lintf//'.IDC_NOMS', nomint), numint)
    endif
!
!
!----------------RECUPERATION DU NOMBRE DE DDL GENERALISES--------------
!
    call dismoi('NB_MODES_TOT', basmod, 'RESULTAT', repi=nbdef)
    nbcol=nbdef
!
!----RECUPERATION DU NOMBRE DE DDL  ET NOEUDS ASSOCIES A L'INTERFACE----
!
    kbid=' '
    call bmrdda(basmod, kbid, nomint, numint, 0,&
                [0], nbddl, ord, ii)
    nblig=nbddl
!
!----------------ALLOCATION DU VECTEUR DES RANGS DES DDL----------------
!
    call wkvect('&&'//pgc//'.RAN.DDL', 'V V I', nbddl, ltrang)
!
!-------------DETERMINATION DES RANG DES DDL ASSOCIES A INTERFACE-------
!
    kbid=' '
    call bmrdda(basmod, kbid, nomint, numint, nbddl,&
                zi(ltrang), ibid, ord, ii)
!
!-----------------ALLOCATION MATRICE LIAISON RESULTAT-------------------
!
!
    call wkvect(nommat, base//' V R', nblig*nbcol, ldmat)
!
!-------------------------EXTRACTION------------------------------------
!
    do i = 1, nbdef
!
        call dcapno(basmod, 'DEPL    ', i, chamva)
        call jeveuo(chamva, 'L', llcham)
!
        do j = 1, nbddl
            iran=zi(ltrang+j-1)
            iad=ldmat+((i-1)*nbddl)+j-1
            zr(iad)=zr(llcham+iran-1)
        end do
!
!
    end do
!
!
    call jedetr('&&'//pgc//'.RAN.DDL')
!
    call jedema()
end subroutine
