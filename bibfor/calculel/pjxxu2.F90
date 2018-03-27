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

subroutine pjxxu2(dim, moa, lima, nbma, klino, nbnoOut)
    implicit none
#include "jeveux.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
!
    character(len=2) :: dim
    character(len=8) :: moa
    character(len=16) :: klino
    integer :: nbma, lima(*), nbnoOut
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
! BUT :
!   ANALYSER LA LISTE DES MAILLES AVANT CONSTRUCTION DE LA LISTE DE NOEUDS
!   PRIS EN COMPTE POUR LA PROJECTION
!
!   CETTE ROUTINE PRODUIT LA LISTE DES NOEUDS (LA LISTE DES MAILLE N'EST
!   PLUS UTILE APRES CONSTRUCTION DE LA LISTE DES NOEUDS)
!   MOA EST LE NOM DU MAILLAGE (OU DU MODELE)
!
!   LES MAILLES UTILES DE MOA SONT CELLES QUI :
!      - SONT D'UN TYPE COHERENT AVEC DIM :
!             PAR EXEMPLE : '2D' -> TRIA/QUAD
!      - SONT INCLUSES DANS LIMA
!
!   LES NOEUDS UTILES DE MOA SONT CEUX QUI SONT PORTES PAR LES
!   MAILLES UTILES DE MOA
!
!
!-----------------------------------------------------------------------
!  IN        DIM    K2:  /'1D'  /'2D'  /'3D'
!
!  IN/JXIN   MOA    K8  : NOM DU MAILLAGE (OU MODELE)
!  IN        KLINO  K16 : NOM DU TABLEAU QUI CONTIENDRA LA LISTE DES NOEUDS
!  IN        NBMA     I   : NOMBRE DE MAILLES DE LIMA
!  IN        LIMA(*)  I   : LISTE DE NUMEROS DE MAILLES
!  OUT       NBNO     I   : NOMBRE DE NOEUDS DE LINO
! ----------------------------------------------------------------------
!
!
    character(len=8) :: ma
    character(len=8) :: notm(10)
!
    integer :: nno, nutm(10), nbtm, i, k, j
    integer :: ima, nbno, ino, nuno, kk
    integer :: iad, ialin1,  ilcnx1
    integer :: iexi
    integer, pointer :: connex(:) => null()
    integer, pointer :: lima_check(:) => null()
    integer, pointer :: linoma(:) => null()
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
!     MOA EST IL UN MODELE OU UN MAILLAGE ?
    call jeexin(moa//'.MODELE    .NBNO', iexi)
    if (iexi .gt. 0) then
        call dismoi('NOM_MAILLA', moa, 'MODELE', repk=ma)
    else
        ma=moa
    endif
!
!
!
!     1 : TYPE_MAILLES UTILES DE MOA :
!     -------------------------------
    if (dim .eq. '1D') then
        nbtm=4
        notm(1)='SEG2'
        notm(2)='SEG3'
        notm(3)='SEG4'
        notm(4)='POI1'

    else if (dim.eq.'2D') then
        nbtm=6
        notm(1)='TRIA3'
        notm(2)='TRIA6'
        notm(3)='TRIA7'
        notm(4)='QUAD4'
        notm(5)='QUAD8'
        notm(6)='QUAD9'
!
    else if (dim.eq.'3D') then
        nbtm=10
        notm(1)='TETRA4'
        notm(2)='TETRA10'
        notm(3)='PENTA6'
        notm(4)='PENTA15'
        notm(5)='PENTA18'
        notm(6)='HEXA8'
        notm(7)='HEXA20'
        notm(8)='HEXA27'
        notm(9)='PYRAM5'
        notm(10)='PYRAM13'
!
    else
        ASSERT(.false.)
    endif
!
    do k = 1, nbtm
        call jenonu(jexnom('&CATA.TM.NOMTM', notm(k)), nutm(k))
    end do
!
!
!
!     2 : MAILLES UTILES DE MOA :
!     ----------------------------
    AS_ALLOCATE(vi=lima_check, size=nbma)
    lima_check(:)=0
    
!    les mailles ne doivent pas necessairement etre portées par un élément fini

    call jeveuo(ma//'.TYPMAIL', 'L', iad)
    do j = 1, nbtm
        do i = 1, nbma
            if (zi(iad-1+lima(i)) .eq. nutm(j)) lima_check(i)= 1
        end do
    end do
!
!
!     3 : NOEUDS UTILES DE MOA :
!     ---------------------------
    call dismoi('NB_NO_MAILLA', ma, 'MAILLAGE', repi=nno)
    AS_ALLOCATE(vi=linoma, size=nno)
    linoma(:)=0
    call jeveuo(ma//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(ma//'.CONNEX', 'LONCUM'), 'L', ilcnx1)
    nbnoOut = 0
    do i = 1, nbma
        if (lima_check(i) .ne. 1) cycle
        ima = lima(i)
        nbno=zi(ilcnx1+ima)-zi(ilcnx1-1+ima)
        do ino = 1, nbno
            nuno=connex(1+zi(ilcnx1-1+ima)-2+ino)
            if (linoma(nuno).eq.0) nbnoOut = nbnoOut + 1
            linoma(nuno)=1
        end do
    end do
    
    AS_DEALLOCATE(vi=lima_check)
    
!   construction de la liste des noeuds
    call wkvect(klino, 'V V I', nbnoOut, ialin1)
    
    kk = 0
    do ino = 1,nno
        if (linoma(ino).eq.1) then
            zi(ialin1+kk)=ino
            kk=kk+1
        endif
    enddo
    ASSERT(nbnoOut.eq.kk)
    AS_DEALLOCATE(vi=linoma)
!
    call jedema()
end subroutine
