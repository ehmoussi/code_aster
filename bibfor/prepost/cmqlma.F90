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

subroutine cmqlma(main, maout, nbma, mailq)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeccta.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: nbma, mailq(nbma)
    character(len=8) :: main, maout
!
!-----------------------------------------------------------------------
!    - COMMANDE :  CREA_MAILLAGE / QUAD_LINE
!    - BUT DE LA COMMANDE:
!      TRANSFORMATION DES MAILLES QUADRATIQUES -> LINEAIRES
!    - BUT DE LA ROUTINE:
!      CREATION DES OBJETS .TYPMAIL .CONNEX DE LA NOUVELLE SD MAILLAGE
!    - ROUTINE APPELEE PAR : CMQLQL
! ----------------------------------------------------------------------
! IN        MAIN    K8   NOM DU MAILLAGE INITIAL
! IN        MAOUT   K8   NOM DU MAILLAGE FINAL
! IN        NBMA     I   NOMBRE DE MAILLES REFERENCEES
! IN        MAILS    I   NUMERO DES MAILLES REFERENCEES
! ----------------------------------------------------------------------
!
!  ======           ==============         ========================
!  MAILLE           TYPE APRES LIN         NBRE DE NOEUDS APRES LIN
!  ======           ==============         ========================
!
!
!  SEG3                      2                       2
!  TRIA6                     7                       3
!  QUAD8                    12                       4
!  QUAD9                    12                       4
!  TETRA10                  18                       4
!  PENTA15                  20                       6
!  PENTA18                  20                       6
!  PYRAM13                  23                       5
!  HEXA20                   25                       8
!  HEXA27                   25                       8
!
!
    integer :: nbtyma
    parameter(nbtyma=27)
    integer ::  i, nbtma,   jtypm2, jconn1, jconn2
    integer :: tymal(nbtyma), num1, num2, nbnol(nbtyma), ityp, j,  nbnomx
    integer :: ndim, ij, numno
    character(len=8) :: nomnoi, vk8(2)
    character(len=24) :: connex, typma
    integer, pointer :: maille(:) => null()
    integer, pointer :: nbno(:) => null()
    integer, pointer :: typmail(:) => null()
    integer, pointer :: dime(:) => null()
!
!     TYMAL: TYPE DES MAILLES APRES LINEARISATION (CF. CI-DESSUS)
!     NBNOL: NOMBRE DE NOEUDS APRES LINEARISATION (CF. CI-DESSUS)
    data tymal   /3*0,2,4*0,7,4*0,12,0,12,2*0,18,0,20,20,0,23,0,25,25/
    data nbnol   /3*0,2,4*0,3,4*0,4 ,0,4 ,2*0,4 ,0,6 ,6, 0,5 ,0,8, 8/
!
    call jemarq()
!
    connex = maout // '.CONNEX'
    typma= maout // '.TYPMAIL'
!
!     CREATION D'UN TABLEAU DIMENSIONNE AU NOMBRE DE MAILLES DU
!     MAILLAGE INITIAL PERMETTANT DE SAVOIR SI LA MAILLE EN COURS
!     SERA LINEAIRE OU NON.
!     -----------------------------------------------------------
    call jeveuo(main//'.DIME', 'L', vi=dime)
    nbtma=dime(3)
    AS_ALLOCATE(vi=maille, size=nbtma)
    do i = 1, nbtma
        maille(i)=0
    end do
    do i = 1, nbma
        maille(1+mailq(i)-1)=1
    end do
!
!     CREATION DES OBJETS  '.TYPMAIL', '.CONNEX':
!     -------------------------------------------
!
    call dismoi('NB_NO_MAX', '&CATA', 'CATALOGUE', repi=nbnomx)
    call jecrec(maout//'.CONNEX', 'G V I', 'NU', 'CONTIG', 'VARIABLE',&
                dime(3))
    ndim=nbnomx*dime(3)
    call jeecra(maout//'.CONNEX', 'LONT', ndim)
    call jeveuo(main//'.TYPMAIL', 'L', vi=typmail)
    call jeveuo(typma, 'E', jtypm2)
    call jeveuo('&CATA.TM.NBNO', 'L', vi=nbno)
!
!     NUM1:NOMBRE DE NOEUDS DE LA MAILLE INITIALE
!     NUM2:NOMBRE DE NOEUDS DE LA MAILLE LINEARISEE
!
!     ON PARCOURT LES MAILLES DU MAILLAGE
    do i = 1, nbtma
        num1=nbno(1+typmail(i)-1)
!
!        '.TYPMAIL':
!        ----------
!        SI LA MAILLE N'EST PAS A LINEARISER
        if (maille(i) .eq. 0) then
            zi(jtypm2+i-1)=typmail(i)
            num2=num1
!        SI LA MAILLE EST A LINEARISER
        else
            ityp=typmail(i)
            zi(jtypm2+i-1)=tymal(ityp)
            num2=nbnol(ityp)
        endif
!
!        '.CONNEX':
!        ----------
        call jecroc(jexnum(connex, i))
        call jeecra(jexnum(connex, i), 'LONMAX', num2)
        call jeveuo(jexnum(connex, i), 'E', jconn2)
        call jeveuo(jexnum(main//'.CONNEX', i), 'L', jconn1)
        do j = 1, num2
            ij=zi(jconn1+j-1)
            call jenuno(jexnum(main//'.NOMNOE', ij), nomnoi)
            call jenonu(jexnom(maout//'.NOMNOE', nomnoi), numno)
            if( numno.eq.0 ) then
                vk8(1) = main
                vk8(2) = nomnoi
                call utmess('F', 'MAILLAGE1_4', nk=2, valk=vk8)
            endif
            zi(jconn2+j-1) = numno
        end do
    end do
!
!     -- RETASSAGE  DE CONNEX (QUI A ETE ALLOUEE TROP GRANDE) :
    call jeccta(connex)
!
    AS_DEALLOCATE(vi=maille)
!
    call jedema()
!
end subroutine
