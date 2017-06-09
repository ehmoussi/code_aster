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

subroutine jesvos(clas)
    implicit none
#include "jeveux_private.h"
#include "asterfort/jjlide.h"
    character(len=*) :: clas
! ----------------------------------------------------------------------
! SAUVEGARDE AVEC ECRITURE DISQUE DES OBJETS (OBJETS SIMPLES OU OBJETS 
! SYSTEME DE COLLECTION) AVANT OPERATION DE RETASSAGE
! ON POURRAIT SE LIMITER AUX OBJETS SIMPLES SYSTEME POSSEDANT $$IADD 
! DANS LEUR NOM, MAIS DE TOUTE FACON IL SERA NECESSAIRE DE TOUS LES
! DECHARGER
!
! IN  CLAS   : NOM DE LA CLASSE ASSOCIEE ( ' ' POUR TOUTES LES CLASSES )
!
!-----------------------------------------------------------------------
    integer :: i
    integer :: j, jcara, jdate, jdocu, jgenr, jhcod, jiadd
    integer :: jiadm, jlong, jlono, jltyp, jluti, jmarq, jorig
    integer :: jrnom, jtype, n, ncla1, ncla2
!-----------------------------------------------------------------------
    parameter  ( n = 5 )
    common /jiatje/  jltyp(n), jlong(n), jdate(n), jiadd(n), jiadm(n),&
     &               jlono(n), jhcod(n), jcara(n), jluti(n), jmarq(n)
!
    common /jkatje/  jgenr(n), jtype(n), jdocu(n), jorig(n), jrnom(n)
!
    integer :: nrhcod, nremax, nreuti
    common /icodje/  nrhcod(n) , nremax(n) , nreuti(n)
!
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe, nomfic(n), kstout(n), kstini(n), dn2(n)
    integer :: iclas, iclaos, iclaco, idatos, idatco, idatoc
    common /iatcje/  iclas ,iclaos , iclaco , idatos , idatco , idatoc
! ----------------------------------------------------------------------
    character(len=1) :: kclas, clasi
    character(len=32) :: crnom
! DEB ------------------------------------------------------------------
!
    kclas = clas ( 1: min(1,len(clas)))
    if (kclas .eq. ' ') then
        ncla1 = 1
        ncla2 = index ( classe , '$' ) - 1
        if (ncla2 .lt. 0) ncla2 = n
    else
        ncla1 = index ( classe , kclas)
        ncla2 = ncla1
    endif
    do i = ncla1, ncla2
        clasi = classe(i:i)
        if (clasi .ne. ' ') then
            iclas = i
            iclaos = i
            do j = 1, nremax(i)
                idatos = j
                crnom = rnom(jrnom(i)+j)
                if (crnom(1:1) .eq. '?') goto 5
                if ( iadd(jiadd(i)+2*j-1) .eq. 0 ) then
                   call jjlide ('JETASS', crnom , 1 )
                endif
 5              continue
            end do 
        endif
    end do
! FIN ------------------------------------------------------------------
end subroutine
