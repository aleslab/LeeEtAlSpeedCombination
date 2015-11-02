function [conditionInfo, screenInfo] = MoveLineTrial(screenInfo)
%function [trialData] = MoveLineTrial(screenInfo, conditionInfo) %this
%returns a too many output arguments error when run through psychmaster
%% making the line move
[screenXpixels, screenYpixels] = Screen('WindowSize', screenInfo.curWindow); 
%get the number of pixels in the window

ifi = Screen('GetFlipInterval', screenInfo.curWindow); %inter-frame interval 
%for the current window on the screen.

vbl=Screen('Flip', screenInfo.curWindow); %flipping to the screen

lw = 1; %linewidth
xinitial = 10; %initial x position for line
xfinal = 200; %where the line ends in x
xv = 5; %speed (most likely Pixels / ifi)

if xinitial > xfinal;
       
    while xinitial > xfinal;
     xinitial=mod(xinitial-xv, screenXpixels); %the part that actually gets 
     %the line to move within the while loop. taking xv off the value to
     %move to the left.
        Screen('DrawLines', screenInfo.curWindow, [xinitial, xinitial ; 0, screenYpixels], lw); 
        vbl=Screen('Flip', screenInfo.curWindow,vbl+ifi/2); %taken from PTB-3 MovingLineDemo
        %if this isn't flipped within the while loop you won't see the line
        %being moved across the window.
    end
else
    while xinitial < xfinal; 
     xinitial=mod(xinitial+xv, screenXpixels); %adding xv onto the value so
     %that the line moves towards the right
        Screen('DrawLines', screenInfo.curWindow, [xinitial, xinitial ; 0, screenYpixels], lw); 
        vbl=Screen('Flip', screenInfo.curWindow,vbl+ifi/2); %taken from PTB-3 MovingLineDemo
        %Drawing and flipping everything onto the screen so that it appears
        %as it should.

    end 
end    

KbStrokeWait;

sca;