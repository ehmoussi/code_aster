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

subroutine ldc_dichoc_endo(ppr, ppi, ppc, yy0, dy0, dyy, decoup)
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: jean-luc.flejou at edf.fr
!
!        DISCRET POUR LE FLAMBEMENT DES GRILLES D'ASSEMBLAGE
!
!  IN
!       ppr     : paramètres réels
!       ppi     : paramètres entiers
!       ppc     : paramètres caractères
!       yy0     : valeurs initiales
!       dy0     : dérivées initiales
!
!  OUT
!       dyy      : dérivées calculées
!       decoup   : pour forcer l'adaptation du pas de temps
!
! --------------------------------------------------------------------------------------------------
!
!     ppi  :
!       1-6 :   informations sur les fonctions (2*nbfct) : ppi(1:2)= (nbvale, jvale)
!                   i [1 , nbvale]
!                       x    = zr(jvale+i)
!                       f(x) = zr(jvale+nbvale+i)
!                           Fp : ppi(1:2)
!                           Kp : ppi(3:4)
!                           Ap : ppi(5:6)
!       7   :   loi de comportement
!                   1   : complète
!                   2   : seulement du contact, pas d'amortissement
!       8   :   intégration du jeu ou pas
!                   0   : pas de fonction d'intégration
!                   1   : intégration
!       9   :   amortissement dans le critère ou pas
!                   1 inclus
!                   2 exclus
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "asterf_types.h"
    real(kind=8)     :: ppr(*)
    integer          :: ppi(*)
    character(len=*) :: ppc(*)
    real(kind=8)     :: yy0(*)
    real(kind=8)     :: dy0(*)
    real(kind=8)     :: dyy(*)
    aster_logical    :: decoup
!
! --------------------------------------------------------------------------------------------------
!
#include "asterfort/assert.h"
!   système d'équations
    integer, parameter  :: iux=1, ifx=2, ivx=3, ip=4, iuanx=5, ije=6
    real(kind=8)        :: Seuil, DSeuil, Raide, DRaide, Ftilde
    real(kind=8)        :: leseuil, ksif, ksiv, nume, deno, xjeu, legap, Raide0
    real(kind=8)        :: Amort_in, DAmort_in, Amort, DAmort
!   Paramètres de la loi : jeu
    integer,parameter   :: ijeu=1
! --------------------------------------------------------------------------------------------------
    decoup = .false.
!   Les incréments de pilotage
    dyy(iux) = dy0(iux)
    dyy(ivx) = dy0(ivx)
    dyy(ije) = dy0(ije)
!   Par défaut rien ne bouge
    dyy(ip)    = 0.0
    dyy(iuanx) = 0.0
    dyy(ifx)   = 0.0
!
!   Soit on intègre le jeu soit on prend sa valeur finale
!       ppi(8) = 1 : intégration du jeu
!       ppi(8) = 0 : valeur finale
    xjeu  = yy0(ije)*ppi(8) + ppr(ijeu)*(1.0 - ppi(8))
    legap = yy0(iux) + xjeu - yy0(iuanx)
!
    if ( legap > 0.0 ) then
        goto 999
    endif
!
!   Loi complète ou pas
!       ppi(7) = 1 : loi complète
!       ppi(7) = 2 : contact direction normale, pas d'amortissement
    if ( ppi(7) == 2 ) then
        ASSERT( ppi(8) == 1 )
!       La fonction raideur et sa dérivée
        call val_fct_dfct(ppi(3),yy0(ip),Raide,DRaide,Raide0)
        dyy(ifx)   = Raide0*(dyy(iux) + dyy(ije))
    else if ( ppi(7) == 1 ) then
!       La fonction seuil et sa dérivée
        call val_fct_dfct(ppi(1),yy0(ip),Seuil,DSeuil)
!       La fonction raideur et sa dérivée
        call val_fct_dfct(ppi(3),yy0(ip),Raide,DRaide)
!       La fonction amortissement et sa dérivée
        call val_fct_dfct(ppi(5),yy0(ip),Amort,DAmort)
        if ( ppi(9).eq. 1 ) then
            Amort_in = Amort; DAmort_in = DAmort
        else
            Amort_in = 0.0;   DAmort_in = 0.0
        endif
!
        Ftilde  = Raide*(yy0(iux)+xjeu-yy0(iuanx)) - Amort_in*abs(yy0(ivx))
        leseuil = abs(Ftilde) - Seuil
        ksiv =  1.0
        if ( yy0(ivx) < 0.0 ) then
            ksiv = -1.0
        endif
        dyy(ifx)   = Raide*(dyy(iux)-dyy(iuanx)) - Amort*ksiv*dyy(ivx)
!       Sous le seuil ou Pas
        if ( leseuil >= 0.0 ) then
            ksif =  1.0
            if ( Ftilde < 0.0 ) then
                ksif = -1.0
            endif
!             nume= ksif*(Raide*dyy(iux) - Amort_in*ksiv*dyy(ivx))
!             deno= DSeuil + Raide - ksif*DRaide*(yy0(iux)+xjeu-yy0(iuanx)) + &
!                   ksif*DAmort_in*abs(yy0(ivx))

            nume= ksif*(Raide*dyy(iux) - Amort*ksiv*dyy(ivx))
            deno= DSeuil + Raide - ksif*DRaide*(yy0(iux)+xjeu-yy0(iuanx)) + &
                  ksif*DAmort*abs(yy0(ivx))
            if ( nume*deno > 0.0 ) then
                dyy(ip)    = nume/deno
                dyy(iuanx) = ksif*dyy(ip)
                dyy(ifx)   = Raide*(dyy(iux)-dyy(iuanx)) + &
                             DRaide*(yy0(iux)+xjeu-yy0(iuanx))*dyy(ip) - &
                             Amort*ksiv*dyy(ivx) - &
                             DAmort*abs(yy0(ivx))*dyy(ip)
            endif
        else
!           Fx doit rester négatif ou nul, lorsque dyy(ifx) > 0.0
            if ((yy0(ifx) >= 0.0).and.(dyy(ifx) > 0.0)) then
                dyy(ifx)   = 0.0
            endif
        endif
    else
        ASSERT( .false. )
    endif
!
999 continue
!
! ==================================================================================================
!
contains
!
subroutine val_fct_dfct(info_fct,p,vfct,dfct,vfct0)
    integer     , intent(in)    :: info_fct(2)
    real(kind=8), intent(in)    :: p
    real(kind=8), intent(out)           :: vfct, dfct
    real(kind=8), intent(out), optional :: vfct0
!
#include "jeveux.h"
#include "asterfort/utmess.h"
!
    integer      :: ip, jr, jp, nbvale, i0, i1
    real(kind=8) :: peq, p0, p1, f0, f1
!
    nbvale = info_fct(1)
    jp     = info_fct(2)
    jr     = jp+nbvale
!   Valeur de la fonction à 0
    if ( present(vfct0) ) then
        vfct0  = zr(jr)
    endif
!
    i0 = 0 ; i1 = 0
    do ip = 1 , nbvale-1
        peq = zr(jp+ip)
        if ( p .lt. peq ) then
            i0 = ip - 1
            i1 = ip
            goto 20
        endif
    enddo
    call utmess('F', 'DISCRETS_61', sk='FxP, RigiP, AmorP', sr=zr(jp+nbvale-1))
20  continue
    f0 = zr(jr+i0) ; f1 = zr(jr+i1)
    p0 = zr(jp+i0) ; p1 = zr(jp+i1)
    dfct = (f1-f0)/(p1-p0)
    vfct = f0 + dfct*(p-p0)
end subroutine val_fct_dfct
!
end subroutine ldc_dichoc_endo
