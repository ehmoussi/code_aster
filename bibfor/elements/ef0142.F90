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

subroutine ef0142(nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/moytem.h"
#include "asterfort/pmfrig.h"
#include "asterfort/poefgr.h"
#include "asterfort/poutre_modloc.h"
#include "asterfort/porigi.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rhoequ.h"
#include "asterfort/utmess.h"
#include "asterfort/vecma.h"
    character(len=16) :: nomte
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, jeffo, labsc, lmater, lopt, nbpar
    integer :: nbref, nbres
    real(kind=8) :: absmoy, cm, phie, phii, rhofe, rhofi, rhos
    real(kind=8) :: valpar
!-----------------------------------------------------------------------
    parameter(nbres=3,nbref=6)
    real(kind=8) :: valres(nbres), valref(nbref)
    integer :: codres(nbres), codref(nbref)
    character(len=8) :: nompar
    character(len=16) :: nomres(nbres), nomref(nbref)
    real(kind=8) :: zero, e, nu, rho
    real(kind=8) :: klv(78), klc(12, 12)
    character(len=24) :: suropt
    integer :: iret
!     ------------------------------------------------------------------
    data nomres/'E','NU','RHO'/
    data nomref/'E','NU','RHO','PROF_RHO_F_INT','PROF_RHO_F_EXT','COEF_MASS_AJOU'/
!     --------------------------------------------------
    integer, parameter :: nb_cara1 = 2
    real(kind=8) :: vale_cara1(nb_cara1)
    character(len=8) :: noms_cara1(nb_cara1)
    data noms_cara1 /'R1','EP1'/
!-----------------------------------------------------------------------
    zero=0.d0
!
!     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
!
    call jevech('PMATERC', 'L', lmater)
    call moytem('NOEU', 2, 1, '+', valpar,&
                iret)
    nompar='TEMP'
    nbpar=1
!
    call jevech('PSUROPT', 'L', lopt)
    suropt=zk24(lopt)
    if (suropt .eq. 'MASS_FLUI_STRU') then
        call jevech('PABSCUR', 'L', labsc)
        call poutre_modloc('CAGEP1', noms_cara1, nb_cara1, lvaleur=vale_cara1)
        absmoy=(zr(labsc-1+1)+zr(labsc-1+2))/2.d0
        call rcvalb('NOEU', 1, 1, '+', zi(lmater),&
                    ' ', 'ELAS_FLUI', 1, 'ABSC', [absmoy],&
                    nbref, nomref, valref, codref, 1)
        e=valref(1)
        nu=valref(2)
        rhos=valref(3)
        rhofi=valref(4)
        rhofe=valref(5)
        cm=valref(6)
        phie = vale_cara1(1)*2.d0
        if (phie .eq. 0.d0) then
            call utmess('F', 'ELEMENTS3_26')
        endif
        phii=(phie-2.d0*vale_cara1(2))
        call rhoequ(rho, rhos, rhofi, rhofe, cm,&
                    phii, phie)
!
    else
        if (nomte .ne. 'MECA_POU_D_EM') then
            call rcvalb('NOEU', 1, 1, '+', zi(lmater),&
                        ' ', 'ELAS', nbpar, nompar, [valpar],&
                        2, nomres, valres, codres, 1)
            call rcvalb('NOEU', 1, 1, '+', zi(lmater),&
                        ' ', 'ELAS', nbpar, nompar, [valpar],&
                        1, nomres(3), valres(3), codres(3), 0)
            if (codres(3) .ne. 0) valres(3)=zero
            e=valres(1)
            nu=valres(2)
            rho=valres(3)
        endif
    endif
!
!     --- CALCUL DE LA MATRICE DE RIGIDITE LOCALE ---
!
    if (nomte .eq. 'MECA_POU_D_EM') then
        call pmfrig(nomte, zi(lmater), klv)
    else
        call porigi(nomte, e, nu, -1.d0, klv)
    endif
!
!     ---- MATRICE RIGIDITE LIGNE > MATRICE RIGIDITE CARRE
!
    call vecma(klv, 78, klc, 12)
!
!
    call jevech('PEFFORR', 'E', jeffo)
    call poefgr(nomte, klc, zi(lmater), e, nu,&
                rho, zr(jeffo))
    do i = 1, 6
        zr(jeffo+i-1)=-zr(jeffo+i-1)
        zr(jeffo+i+6-1)=zr(jeffo+i+6-1)
    end do
!
end subroutine
