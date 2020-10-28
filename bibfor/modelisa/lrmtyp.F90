! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: nicolas.sellenet at edf.fr
! aslint: disable=W1502
!
subroutine lrmtyp(nbtyp, nomtyp, nnotyp, typgeo, renumd,&
                  modnum, nuanom, numnoa)
!
implicit none
!
#include "jeveux.h"
#include "MeshTypes_type.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
integer, intent(out), optional :: nbtyp
character(len=8), intent(out), optional :: nomtyp(MT_NTYMAX)
integer, intent(out), optional :: nnotyp(MT_NTYMAX), typgeo(MT_NTYMAX)
integer, intent(out), optional :: renumd(MT_NTYMAX), modnum(MT_NTYMAX)
integer, intent(out), optional :: nuanom(MT_NTYMAX, MT_NNOMAX)
integer, intent(out), optional :: numnoa(MT_NTYMAX, MT_NNOMAX)
!
! --------------------------------------------------------------------------------------------------
!
! Returns several informations to map the aster cells types and the med ones.
!
! Outputs:
!   nbtyp   : number of cells types supported by med (and used in aster)
!   nomtyp  : array of aster cells names
!   nnotyp  : number of nodes for each cell type
!   typgeo  : array of med cells types
!   renumd  : redirection array (size: nbtyp_):
!               #supported_type => #type_index in typgeo_
!   modnum  : array that tells if the connectivity differs between med and aster
!               modnum_ = 0 : same nodes numbering
!               modnum_ = 1 : different nodes numbering
!   nuanom  : mapping array of connectivity med to aster
!               nuanom_(ityp, k) = j : node k in med is the node j in aster
!   numnoa  : mapping array of connectivity aster to med
!               numnoa_(ityp, j) = k : node j in aster is the node k in med
!
! --------------------------------------------------------------------------------------------------
!   local variables for optional arguments
    integer :: nbtyp_
    character(len=8) :: nomtyp_(MT_NTYMAX)
    integer :: nnotyp_(MT_NTYMAX), typgeo_(MT_NTYMAX)
    integer :: renumd_(MT_NTYMAX), modnum_(MT_NTYMAX)
    integer :: nuanom_(MT_NTYMAX, MT_NNOMAX)
    integer :: numnoa_(MT_NTYMAX, MT_NNOMAX)
!
    integer :: iaux, jaux, ityp
    character(len=8), parameter :: nomast(MT_NTYMAX) = (/'POI1    ','SEG2    ','SEG22   ',&
                                                         'SEG3    ','SEG33   ','SEG4    ',&
                                                         'TRIA3   ','TRIA33  ','TRIA6   ',&
                                                         'TRIA66  ','TRIA7   ','QUAD4   ',&
                                                         'QUAD44  ','QUAD8   ','QUAD88  ',&
                                                         'QUAD9   ','QUAD99  ','TETRA4  ',&
                                                         'TETRA10 ','PENTA6  ','PENTA15 ',&
                                                         'PENTA18 ','PYRAM5  ','PYRAM13 ',&
                                                         'HEXA8   ','HEXA20  ','HEXA27  ',&
                                                         'TETRA9  ','TRIA4   ',           &
                                                         'TR3QU4  ','QU4TR3  ','TR6TR3  ',&
                                                         'TR3TR6  ','TR6QU4  ','QU4TR6  ',&
                                                         'TR6QU8  ','QU8TR6  ','TR6QU9  ',&
                                                         'QU9TR6  ','QU8TR3  ','TR3QU8  ',&
                                                         'QU8QU4  ','QU4QU8  ','QU8QU9  ',&
                                                         'QU9QU8  ','QU9QU4  ','QU4QU9  ',&
                                                         'QU9TR3  ','TR3QU9  ','SEG32   ',&
                                                         'SEG23   ','QU4QU4  ','TR3TR3  ',&
                                                         'HE8HE8  ','PE6PE6  ','TE4TE4  ',&
                                                         'QU8QU8  ','TR6TR6  ','SE2TR3  ',&
                                                         'SE2TR6  ','SE2QU4  ','SE2QU8  ',&
                                                         'SE2QU9  ','SE3TR3  ','SE3TR6  ',&
                                                         'SE3QU4  ','SE3QU8  ','SE3QU9  ',&
                                                         'H20H20  ','P15P15  ','T10T10  '/)
    integer, parameter :: nummed(MT_NTYMAX) = (/1  , 102, 0  ,&
                                                103, 0  , 104,&
                                                203, 0  , 206,&
                                                0  , 207, 204,&
                                                0  , 208, 0  ,&
                                                209, 0  , 304,&
                                                310, 306, 315,&
                                                318, 305, 313,&
                                                308, 320, 327,&
                                                0  , 0  ,     &
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  ,&
                                                0  , 0  , 0  /)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
!     VERIFICATION QUE LE CATALOGUE EST ENCORE COHERENT AVEC LE FORTRAN
!
    call jelira('&CATA.TM.NOMTM', 'NOMMAX', iaux)
    if (MT_NTYMAX .ne. iaux) then
        call utmess('F', 'MED_38')
    endif
!
!     NOM / NBNO PAR TYPE DE MAILLE
!
    do ityp = 1, MT_NTYMAX
        call jenuno(jexnum('&CATA.TM.NOMTM', ityp), nomtyp_(ityp))
        if (nomast(ityp) .ne. nomtyp_(ityp)) then
            call utmess('F', 'MED_39')
        endif
        call jeveuo(jexnum('&CATA.TM.NBNO' , ityp), 'L', jaux)
        nnotyp_(ityp) = zi(jaux)
        typgeo_(ityp) = nummed(ityp)
!
    end do
!
    nbtyp_ = 0
    do ityp = 1 , MT_NTYMAX
        if (nummed(ityp) .ne. 0) then
            do iaux = 1 , nbtyp_
                if (nummed(ityp) .lt. nummed(renumd_(iaux))) then
                    jaux = iaux
                    goto 212
                endif
            enddo
            jaux = nbtyp_ + 1
 212        continue
            nbtyp_ = nbtyp_ + 1
            do iaux = nbtyp_ , jaux + 1 , -1
                renumd_(iaux) = renumd_(iaux-1)
            enddo
            renumd_(jaux) = ityp
        endif
    end do
!
!====
! 3. CHANGEMENT DE CONVENTION DANS LES CONNECTIVITES ENTRE ASTER ET MED
!====
!
! 3.1. ==> PAR DEFAUT, LES DEUX NUMEROTATIONS SONT IDENTIQUES
!
    do iaux = 1 , MT_NTYMAX
        modnum_(iaux) = 0
        do jaux = 1 , MT_NNOMAX
            nuanom_(iaux,jaux) = 0
            numnoa_(iaux,jaux) = 0
        end do
    end do
!
! 3.2. ==> MODIFICATIONS POUR LES TETRAEDRES
!       ------ TETRA4 -------
!
    modnum_(18)=1
!
    numnoa_(18,1)=1
    numnoa_(18,2)=3
    numnoa_(18,3)=2
    numnoa_(18,4)=4

    nuanom_(18,1)=1
    nuanom_(18,2)=3
    nuanom_(18,3)=2
    nuanom_(18,4)=4
!
!       ------ TETRA10 -------
!
    modnum_(19)=1
!
    numnoa_(19,1)=1
    numnoa_(19,2)=3
    numnoa_(19,3)=2
    numnoa_(19,4)=4
    numnoa_(19,5)=7
    numnoa_(19,6)=6
    numnoa_(19,7)=5
    numnoa_(19,8)=8
    numnoa_(19,9)=10
    numnoa_(19,10)=9

    nuanom_(19,1)=1
    nuanom_(19,2)=3
    nuanom_(19,3)=2
    nuanom_(19,4)=4
    nuanom_(19,5)=7
    nuanom_(19,6)=6
    nuanom_(19,7)=5
    nuanom_(19,8)=8
    nuanom_(19,9)=10
    nuanom_(19,10)=9
!
! 3.3. ==> MODIFICATIONS POUR LES PENTAEDRES
!       ------ PENTA6 -------
!
    modnum_(20)=1
!
    numnoa_(20,1)=1
    numnoa_(20,2)=3
    numnoa_(20,3)=2
    numnoa_(20,4)=4
    numnoa_(20,5)=6
    numnoa_(20,6)=5

    nuanom_(20,1)=1
    nuanom_(20,2)=3
    nuanom_(20,3)=2
    nuanom_(20,4)=4
    nuanom_(20,5)=6
    nuanom_(20,6)=5
!
!       ------ PENTA15 -------
!
    modnum_(21)=1
!
    numnoa_(21,1)=1
    numnoa_(21,2)=3
    numnoa_(21,3)=2
    numnoa_(21,4)=4
    numnoa_(21,5)=6
    numnoa_(21,6)=5
    numnoa_(21,7)=9
    numnoa_(21,8)=8
    numnoa_(21,9)=7
    numnoa_(21,10)=13
    numnoa_(21,11)=15
    numnoa_(21,12)=14
    numnoa_(21,13)=12
    numnoa_(21,14)=11
    numnoa_(21,15)=10

    nuanom_(21,1)=1
    nuanom_(21,2)=3
    nuanom_(21,3)=2
    nuanom_(21,4)=4
    nuanom_(21,5)=6
    nuanom_(21,6)=5
    nuanom_(21,7)=9
    nuanom_(21,8)=8
    nuanom_(21,9)=7
    nuanom_(21,10)=15
    nuanom_(21,11)=14
    nuanom_(21,12)=13
    nuanom_(21,13)=10
    nuanom_(21,14)=12
    nuanom_(21,15)=11
!
!       ------ PENTA18 -------
!
    modnum_(22)=1
!
    numnoa_(22,1)=1
    numnoa_(22,2)=3
    numnoa_(22,3)=2
    numnoa_(22,4)=4
    numnoa_(22,5)=6
    numnoa_(22,6)=5
    numnoa_(22,7)=9
    numnoa_(22,8)=8
    numnoa_(22,9)=7
    numnoa_(22,10)=13
    numnoa_(22,11)=15
    numnoa_(22,12)=14
    numnoa_(22,13)=12
    numnoa_(22,14)=11
    numnoa_(22,15)=10
    numnoa_(22,16)=18
    numnoa_(22,17)=17
    numnoa_(22,18)=16

    nuanom_(22,1)=1
    nuanom_(22,2)=3
    nuanom_(22,3)=2
    nuanom_(22,4)=4
    nuanom_(22,5)=6
    nuanom_(22,6)=5
    nuanom_(22,7)=9
    nuanom_(22,8)=8
    nuanom_(22,9)=7
    nuanom_(22,10)=15
    nuanom_(22,11)=14
    nuanom_(22,12)=13
    nuanom_(22,13)=10
    nuanom_(22,14)=12
    nuanom_(22,15)=11
    nuanom_(22,16)=18
    nuanom_(22,17)=17
    nuanom_(22,18)=16
!
!
! 3.4. ==> MODIFICATIONS POUR LES PYRAMIDES
!       ------ PYRAM5 -------
!
    modnum_(23)=1
!
    numnoa_(23,1)=1
    numnoa_(23,2)=4
    numnoa_(23,3)=3
    numnoa_(23,4)=2
    numnoa_(23,5)=5

    nuanom_(23,1)=1
    nuanom_(23,2)=4
    nuanom_(23,3)=3
    nuanom_(23,4)=2
    nuanom_(23,5)=5
!
!       ------ PYRAM13 -------
    modnum_(24)=1
!
    numnoa_(24,1)=1
    numnoa_(24,2)=4
    numnoa_(24,3)=3
    numnoa_(24,4)=2
    numnoa_(24,5)=5
    numnoa_(24,6)=9
    numnoa_(24,7)=8
    numnoa_(24,8)=7
    numnoa_(24,9)=6
    numnoa_(24,10)=10
    numnoa_(24,11)=13
    numnoa_(24,12)=12
    numnoa_(24,13)=11

    nuanom_(24,1)=1
    nuanom_(24,2)=4
    nuanom_(24,3)=3
    nuanom_(24,4)=2
    nuanom_(24,5)=5
    nuanom_(24,6)=9
    nuanom_(24,7)=8
    nuanom_(24,8)=7
    nuanom_(24,9)=6
    nuanom_(24,10)=10
    nuanom_(24,11)=13
    nuanom_(24,12)=12
    nuanom_(24,13)=11
!
!
! 3.2. ==> MODIFICATIONS POUR LES HEXAEDRES
!
!       ------ HEXA8 -------
!
    modnum_(25)=1
!
    numnoa_(25,1)=1
    numnoa_(25,2)=4
    numnoa_(25,3)=3
    numnoa_(25,4)=2
    numnoa_(25,5)=5
    numnoa_(25,6)=8
    numnoa_(25,7)=7
    numnoa_(25,8)=6

    nuanom_(25,1)=1
    nuanom_(25,2)=4
    nuanom_(25,3)=3
    nuanom_(25,4)=2
    nuanom_(25,5)=5
    nuanom_(25,6)=8
    nuanom_(25,7)=7
    nuanom_(25,8)=6
!
!       ------ HEXA20 -------
!
    modnum_(26)=1
!
    numnoa_(26,1)=1
    numnoa_(26,2)=4
    numnoa_(26,3)=3
    numnoa_(26,4)=2
    numnoa_(26,5)=5
    numnoa_(26,6)=8
    numnoa_(26,7)=7
    numnoa_(26,8)=6
    numnoa_(26,9)=12
    numnoa_(26,10)=11
    numnoa_(26,11)=10
    numnoa_(26,12)=9
    numnoa_(26,13)=17
    numnoa_(26,14)=20
    numnoa_(26,15)=19
    numnoa_(26,16)=18
    numnoa_(26,17)=16
    numnoa_(26,18)=15
    numnoa_(26,19)=14
    numnoa_(26,20)=13

    nuanom_(26,1)=1
    nuanom_(26,2)=4
    nuanom_(26,3)=3
    nuanom_(26,4)=2
    nuanom_(26,5)=5
    nuanom_(26,6)=8
    nuanom_(26,7)=7
    nuanom_(26,8)=6
    nuanom_(26,9)=12
    nuanom_(26,10)=11
    nuanom_(26,11)=10
    nuanom_(26,12)=9
    nuanom_(26,13)=20
    nuanom_(26,14)=19
    nuanom_(26,15)=18
    nuanom_(26,16)=17
    nuanom_(26,17)=13
    nuanom_(26,18)=16
    nuanom_(26,19)=15
    nuanom_(26,20)=14
!
!       ------ HEXA27 -------
!
    modnum_(27)=1
!
    numnoa_(27,1)=1
    numnoa_(27,2)=4
    numnoa_(27,3)=3
    numnoa_(27,4)=2
    numnoa_(27,5)=5
    numnoa_(27,6)=8
    numnoa_(27,7)=7
    numnoa_(27,8)=6
    numnoa_(27,9)=12
    numnoa_(27,10)=11
    numnoa_(27,11)=10
    numnoa_(27,12)=9
    numnoa_(27,13)=17
    numnoa_(27,14)=20
    numnoa_(27,15)=19
    numnoa_(27,16)=18
    numnoa_(27,17)=16
    numnoa_(27,18)=15
    numnoa_(27,19)=14
    numnoa_(27,20)=13
    numnoa_(27,21)=21
    numnoa_(27,22)=25
    numnoa_(27,23)=24
    numnoa_(27,24)=23
    numnoa_(27,25)=22
    numnoa_(27,26)=26
    numnoa_(27,27)=27

    nuanom_(27,1)=1
    nuanom_(27,2)=4
    nuanom_(27,3)=3
    nuanom_(27,4)=2
    nuanom_(27,5)=5
    nuanom_(27,6)=8
    nuanom_(27,7)=7
    nuanom_(27,8)=6
    nuanom_(27,9)=12
    nuanom_(27,10)=11
    nuanom_(27,11)=10
    nuanom_(27,12)=9
    nuanom_(27,13)=20
    nuanom_(27,14)=19
    nuanom_(27,15)=18
    nuanom_(27,16)=17
    nuanom_(27,17)=13
    nuanom_(27,18)=16
    nuanom_(27,19)=15
    nuanom_(27,20)=14
    nuanom_(27,21)=21
    nuanom_(27,22)=25
    nuanom_(27,23)=24
    nuanom_(27,24)=23
    nuanom_(27,25)=22
    nuanom_(27,26)=26
    nuanom_(27,27)=27
!
    call jedema()
!
! Outputs:
    if (present(nbtyp)) then
        nbtyp = nbtyp_
    endif
    if (present(nomtyp)) then
        nomtyp = nomtyp_
    endif
    if (present(nnotyp)) then
        nnotyp = nnotyp_
    endif
    if (present(typgeo)) then
        typgeo = typgeo_
    endif
    if (present(renumd)) then
        renumd = renumd_
    endif
    if (present(modnum)) then
        modnum = modnum_
    endif
    if (present(nuanom)) then
        nuanom = nuanom_
    endif
    if (present(numnoa)) then
        numnoa = numnoa_
    endif
    !
end subroutine
