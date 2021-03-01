function plot_pendulum(x)
    % x(:,1) = pendulum angle
    % x(:,2) = pendulum angle velocity
    % x(:,3) = cart position
    % x(:,4) = cart velocity
    

    l = 0.304;    % pendulum length

    cart_x = [-1,1,1,-1,-1]*0.2;
    cart_y = ([1,1,-1,-1,1]-1)*0.2;
    
    xp = x(:,3)-l*sin(x(:,1));
    yp = l*cos(x(:,1));
    
    
    h = figure('Color','white');
            set(h,'Units','normalized','Position',[0.1 0.3 0.75 0.1]);
            hold on;
    ylim([-0.5, 0.4]);
    xlim(2*[-1,1]);
    axis equal
    for i=1:length(xp)
        if mod(i,10)==0
            cla
            ylim([-0.5, 0.4]);
            xlim(2*[-1,1]);
            axis equal
            hold on;
        else
            fill([-10,-10,10,10],[0.4,-0.5,-0.5,0.4],[1,1,1]);
        end
        hold on;
        drawnow;
        plot(cart_x+x(i,3),cart_y,'k');
        plot([x(i,3), xp(i)],[0, yp(i)],'k');
        pause(0.15);

    end

end

