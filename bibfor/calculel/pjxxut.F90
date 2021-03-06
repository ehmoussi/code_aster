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

subroutine pjxxut(dim, mocle, moa1, moa2, nbma1,&
                  lima1, nbno2, lino2, ma1, ma2,&
                  nbtmx, nbtm, nutm, elrf)
! aslint: disable=W1306
    implicit none
#include "jeveux.h"
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
#include "asterfort/pjnout.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=2) :: dim
    character(len=8) :: moa1, moa2, ma1, ma2
    character(len=*) :: mocle
    integer :: nbma1, lima1(*), nbno2, lino2(*), nbtmx, nbtm, nutm(nbtmx)
    character(len=8) :: elrf(nbtmx)
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
! BUT :
!   PREPARER LA LISTE DES MAILLES ET LES LISTES DE NOEUDS
!   UTILES A LA PROJECTION:
!
!   CETTE ROUTINE PRODUIT LES OBJETS SUIVANTS :
!    '&&PJXXCO.LIMA1' : NUMEROS DES MAILLES UTILES DE MOA1
!    '&&PJXXCO.LINO1' : NUMEROS DES NOEUDS UTILES DE MOA1
!    '&&PJXXCO.LINO2' : NUMEROS DES NOEUDS UTILES DE MOA2
!
!   M1 EST LE NOM DU MAILLAGE (OU DU MODELE) INITIAL
!   M2 EST LE NOM DU MAILLAGE (OU DU MODELE) FINAL
!
!   LES MAILLES UTILES DE MOA1 SONT CELLES QUI :
!      - SONT D'UN TYPE COHERENT AVEC DIM :
!             PAR EXEMPLE : '2D' -> TRIA/QUAD
!      - SONT PORTEUSES D'ELEMENTS FINIS (SI M1 EST UN MODELE)
!      - SONT INCLUSES DANS LIMA1 (SI MOCLE='PARTIE')
!
!   LES NOEUDS UTILES DE MOA1 SONT CEUX QUI SONT PORTES PAR LES
!   MAILLES UTILES DE MOA1
!
!   LES NOEUD UTILES DE MOA2 SONT CEUX QUI :
!      - SONT PORTES PAR LES MAILLES SUPPORTANT LES ELEMENTS FINIS
!        (SI M1 EST UN MODELE)
!      - SONT INCLUS DANS LINO2 (SI MOCLE='PARTIE')
!
!  SI MOCLE='TOUT' :
!     - ON NE SE SERT PAS DE NBMA1,LIMA1,NBNO2,LINO2
!
!-----------------------------------------------------------------------
!  IN        DIM    K2:  /'1D'  /'2D'  /'3D'
!  IN        MOCLE  K*:  /'TOUT'  /'PARTIE'
!
!  IN/JXIN   MOA1    K8  : NOM DU MAILLAGE (OU MODELE) INITIAL
!  IN/JXIN   MOA2    K8  : NOM DU MAILLAGE (OU MODELE) SUR LEQUEL ON
!                          VEUT PROJETER
!
!  IN        NBMA1    I   : NOMBRE DE MAILLES DE LIMA1
!  IN        LIMA1(*) I   : LISTE DE NUMEROS DE MAILLES (DE MOA1)
!  IN        NBNO2    I   : NOMBRE DE NOEUDS DE LINO2
!  IN        LINO2(*) I   : LISTE DE NUMEROS DE NOEUDS (DE MOA2)
!  OUT       MA1      K8  : NOM DU MAILLAGE ASSOCIE A MOA1
!  OUT       MA2      K8  : NOM DU MAILLAGE ASSOCIE A MOA2
!  IN        NBTMX    I   : DIMENSION DU TABLEAU NUTM
!  OUT       NBTM     I   : NOMBRE DE TYPE_MAILLE POUR DIM
!  OUT       NUTM(*)  I   : NUMEROS DES TYPE_MAILLE POUR DIM
!  OUT       ELRF(*)  K8  : ELREFES DES TYPE_MAILLE POUR DIM
! ----------------------------------------------------------------------
!
!
    character(len=8) :: mo1, mo2
    character(len=8) :: notm(nbtmx)
!
    integer :: nno1, nno2, nma1, nma2, i, k, j
    integer :: ima, nbno, ino, nuno, ino2, kk, ima1
    integer :: ialim1, iad, long, ialin1,  ilcnx1, ialin2
    integer :: iexi
    integer, pointer :: connex(:) => null()
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
!     MOA1 EST IL UN MODELE OU UN MAILLAGE ?
    call jeexin(moa1//'.MODELE    .NBNO', iexi)
    if (iexi .gt. 0) then
        mo1=moa1
        call dismoi('NOM_MAILLA', mo1, 'MODELE', repk=ma1)
    else
        mo1=' '
        ma1=moa1
    endif
!
!     MOA2 EST IL UN MODELE OU UN MAILLAGE ?
    call jeexin(moa2//'.MODELE    .NBNO', iexi)
    if (iexi .gt. 0) then
        mo2=moa2
        call dismoi('NOM_MAILLA', mo2, 'MODELE', repk=ma2)
        call pjnout(mo2)
    else
        mo2=' '
        ma2=moa2
    endif
!
!
    call dismoi('NB_NO_MAILLA', ma1, 'MAILLAGE', repi=nno1)
    call dismoi('NB_NO_MAILLA', ma2, 'MAILLAGE', repi=nno2)
    call dismoi('NB_MA_MAILLA', ma1, 'MAILLAGE', repi=nma1)
    call dismoi('NB_MA_MAILLA', ma2, 'MAILLAGE', repi=nma2)
!
!
!
!     1 : TYPE_MAILLES UTILES DE MOA1 :
!     ----------------------------------
    if (dim .eq. '1D') then
        nbtm=3
        notm(1)='SEG2'
        notm(2)='SEG3'
        notm(3)='SEG4'
!
        elrf(1)='SE2'
        elrf(2)='SE3'
        elrf(3)='SE4'
    else if (dim.eq.'2D') then
        nbtm=6
        notm(1)='TRIA3'
        notm(2)='TRIA6'
        notm(3)='TRIA7'
        notm(4)='QUAD4'
        notm(5)='QUAD8'
        notm(6)='QUAD9'
!
        elrf(1)='TR3'
        elrf(2)='TR6'
        elrf(3)='TR7'
        elrf(4)='QU4'
        elrf(5)='QU8'
        elrf(6)='QU9'
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
        elrf(1)='TE4'
        elrf(2)='T10'
        elrf(3)='PE6'
        elrf(4)='P15'
        elrf(5)='P18'
        elrf(6)='HE8'
        elrf(7)='H20'
        elrf(8)='H27'
        elrf(9)='PY5'
        elrf(10)='P13'
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
!     2 : MAILLES UTILES DE MOA1 :
!     ----------------------------
    call wkvect('&&PJXXCO.LIMA1', 'V V I', nma1, ialim1)
    if (mo1 .ne. ' ') then
        call jeveuo(mo1//'.MAILLE', 'L', iad)
        call jelira(mo1//'.MAILLE', 'LONMAX', long)
        do i = 1, long
            if (zi(iad-1+i) .ne. 0) zi(ialim1-1+i)=1
        end do
    else
        do i = 1, nma1
            zi(ialim1-1+i)=1
        end do
    endif
!
    call jeveuo(ma1//'.TYPMAIL', 'L', iad)
    do j = 1, nbtm
        do i = 1, nma1
            if (zi(iad-1+i) .eq. nutm(j)) zi(ialim1-1+i)=zi(ialim1-1+i)+ 1
        end do
    end do
!
    do i = 1, nma1
        if (zi(ialim1-1+i) .eq. 1) then
            zi(ialim1-1+i)=0
        else if (zi(ialim1-1+i).eq.2) then
            zi(ialim1-1+i)=1
        else if (zi(ialim1-1+i).gt.2) then
            ASSERT(.false.)
        endif
    end do
!
    if (mocle .eq. 'PARTIE') then
        do ima1 = 1, nbma1
            zi(ialim1-1+lima1(ima1))=2*zi(ialim1-1+lima1(ima1))
        end do
        do ima1 = 1, nma1
            zi(ialim1-1+ima1)=zi(ialim1-1+ima1)/2
        end do
    endif
!
!
!     3 : NOEUDS UTILES DE MOA1 :
!     ---------------------------
    call wkvect('&&PJXXCO.LINO1', 'V V I', nno1, ialin1)
    call jeveuo(ma1//'.CONNEX', 'L', vi=connex)
    call jeveuo(jexatr(ma1//'.CONNEX', 'LONCUM'), 'L', ilcnx1)
    do ima = 1, nma1
        if (zi(ialim1-1+ima) .eq. 0) goto 100
        nbno=zi(ilcnx1+ima)-zi(ilcnx1-1+ima)
        do ino = 1, nbno
            nuno=connex(1+zi(ilcnx1-1+ima)-2+ino)
            zi(ialin1-1+nuno)=1
        end do
100     continue
    end do
!
!
!     4 : NOEUDS UTILES DE MOA2 :
!     ---------------------------
    call wkvect('&&PJXXCO.LINO2', 'V V I', nno2, ialin2)
!
    if (mo2 .ne. ' ') then
        call jeveuo(mo2//'.NOEUD_UTIL', 'L', iad)
        if (mocle .eq. 'TOUT') then
            do ino = 1, nno2
                if (zi(iad-1+ino) .ne. 0) zi(ialin2-1+ino)=1
            end do
        else if (mocle.eq.'PARTIE') then
            do ino2 = 1, nbno2
                if (zi(iad-1+lino2(ino2)) .ne. 0) zi(ialin2-1+lino2(ino2) )=1
            end do
        endif
    else
        if (mocle .eq. 'TOUT') then
            do ino = 1, nno2
                zi(ialin2-1+ino)=1
            end do
        else if (mocle.eq.'PARTIE') then
            do ino2 = 1, nbno2
                zi(ialin2-1+lino2(ino2))=1
            end do
        endif
    endif
!
!
!     ON ARRETE S'IL N'Y A PAS DE NOEUDS "2" :
!     ------------------------------------------------
    kk=0
    do k = 1, nno2
        if (zi(ialin2-1+k) .gt. 0) kk=kk+1
    end do
    if (kk .eq. 0) then
        call utmess('F', 'CALCULEL4_54')
    endif
!
    call jedema()
end subroutine
