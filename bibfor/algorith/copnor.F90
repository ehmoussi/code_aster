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

subroutine copnor(noma, ds_contact, posmai, ksi1,&
                  ksi2, tau1, tau2)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/apvect.h"
#include "asterfort/assert.h"
#include "asterfort/cfnben.h"
#include "asterfort/cfnumm.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mmcoor.h"
#include "asterfort/mmmron.h"
#include "asterfort/mmnorm.h"
#include "asterfort/mmtann.h"
#include "asterfort/mmtypm.h"
#include "asterfort/normev.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: posmai
    real(kind=8) :: tau1(3), tau2(3)
    character(len=8) :: noma
    type(NL_DS_Contact), intent(in) :: ds_contact
    real(kind=8) :: ksi1, ksi2
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT)
!
! CALCUL DES VECTEURS TANGENTS LOCAUX EN UN POINT
! ON PROCEDE PAR INTERPOLATION LINEAIRE DES VECTEURS TANGENTS
! AUX NOEUDS DE LA MAILLE
!
! ----------------------------------------------------------------------
!
! NB: CONFUSION NOEUD/POINT DE CONTACT CAR LES OPTIONS FONCTIONNENT
! QUE POUR INTEGRATION='NOEUD'
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  POSMAI : MAILLE QUI RECOIT LA PROJECTION
! IN  KSI1   : COORDONNEE X DU POINT PROJETE
! IN  KSI2   : COORDONNEE Y DU POINT PROJETE
! In  ds_contact       : datastructure for contact management
! OUT TAU1   : PREMIERE TANGENTE LOCALE AU POINT PROJETE
! OUT TAU2   : SECONDE TANGENTE LOCALE AU POINT ROJETE
!
!
!
!
    real(kind=8), parameter :: zero =  0.d0 
    character(len=24) :: nomaco
    integer :: jnoma
    character(len=19) :: sdappa
    integer :: jdecno, posno, nummai
    integer :: ino, idim, iret
    integer :: ndim, nno
    real(kind=8) :: vecta1(27), vecta2(27), vecnor(27)
    real(kind=8) :: norm(3), noor
    character(len=8) :: alias
!
! ----------------------------------------------------------------------
!
!
! --- RECUPERATION DE QUELQUES DONNEES
!
    nomaco = ds_contact%sdcont_defi(1:16)//'.NOMACO'
    call jeveuo(nomaco, 'L', jnoma)
!
! --- LECTURE APPARIEMENT
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! --- INITIALISATIONS
!
    tau1(1:3) = zero
    tau2(1:3) = zero
    norm(1:3) = zero
!
! --- MAILLE COURANTE
!
    call cfnumm(ds_contact%sdcont_defi, posmai, nummai)
    call cfnben(ds_contact%sdcont_defi, posmai, 'CONNEX', nno, jdecno)
    call mmtypm(noma, nummai, nno, alias, ndim)
!
! --- RECUPERATIONS DES TANGENTES AU NOEUD
!
    do ino = 1, nno
        posno = zi(jnoma+jdecno+ino-1)
        call apvect(sdappa, 'APPARI_NOEUD_TAU1', posno, tau1)
        call apvect(sdappa, 'APPARI_NOEUD_TAU2', posno, tau2)
        do idim = 1, 3
            vecta1(3*(ino-1)+idim) = tau1(idim)
            vecta2(3*(ino-1)+idim) = tau2(idim)
        end do
    end do
!
! --- VECTEURS NORMAUX LISSES AUX NOEUDS DE LA MAILLE (DEJA NORMES)
!
    do ino = 1, nno
        call mmnorm(ndim, vecta1(3*(ino-1)+1), vecta2(3*(ino-1)+1), vecnor(3*(ino-1)+1), noor)
    end do
!
! --- NORMALE EN CE POINT PAR INTERPOLATION A PARTIR DES VALEURS NODALES
!
    call mmcoor(alias, nno, ndim, vecnor, ksi1,&
                ksi2, norm)
!
! --- NORMALISATION DE LA NORMALE
!
    call normev(norm, noor)
    if (noor .le. r8prem()) then
        ASSERT(.false.)
    endif
!
! --- RECONSTRUCTION DES TANGENTES
!
    call mmmron(ndim, norm, tau1, tau2)
!
! --- NORMALISATION DES TANGENTES
!
    call mmtann(ndim, tau1, tau2, iret)
    if (iret .ne. 0) then
        ASSERT(.false.)
    endif
!
end subroutine
